//
//  PortfolioSummaryDrawerView.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import UIKit

final class PortfolioSummaryDrawerView: UIView {
    private let containerView = UIStackView()
    private let expandedContentStackView = UIStackView()
    
    private let profitAndLossStackView = UIStackView()
    private let profitAndLossTitleLabel = UILabel()
    private let profitAndLossValueLabel = UILabel()
    private let iconImageView = UIImageView()
    private let imageTitleContainer = UIView()
    
    private let currentValueStackView = UIStackView()
    private let currentValueTitleLabel = UILabel()
    private let currentValueLabel = UILabel()
    
    private let totalInvestmentStackView = UIStackView()
    private let totalInvestmentTitleLabel = UILabel()
    private let totalInvestmentValueLabel = UILabel()
    
    private let todayPNLStackView = UIStackView()
    private let todayPNLTitleLabel = UILabel()
    private let todayPNLValueLabel = UILabel()
    
    private let dividerView = UIView()
    private var isExpanded: Bool = false
    private var stackViewTopAnchorConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
        setTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        
        containerView.axis = .vertical
        containerView.spacing = 12
        
        setTranslatesAutoresizingMaskIntoConstraints(for: [
            containerView,
            expandedContentStackView,
            profitAndLossStackView,
            profitAndLossTitleLabel,
            profitAndLossValueLabel,
            iconImageView,
            imageTitleContainer,
            currentValueStackView,
            currentValueTitleLabel,
            currentValueLabel,
            totalInvestmentStackView,
            totalInvestmentTitleLabel,
            totalInvestmentValueLabel,
            todayPNLStackView,
            todayPNLTitleLabel,
            todayPNLValueLabel
        ])
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(systemName: "chevron.down")
        
        profitAndLossTitleLabel.setTextWithSuperscript(text: "Profit & Loss", superscriptText: "*")
        currentValueTitleLabel.setTextWithSuperscript(text: "Current Value", superscriptText: "*")
        totalInvestmentTitleLabel.setTextWithSuperscript(text: "Total Investment", superscriptText: "*")
        todayPNLTitleLabel.setTextWithSuperscript(text: "Today's Profit and Loss", superscriptText: "*")
        
        [profitAndLossTitleLabel,
         currentValueTitleLabel,
         totalInvestmentTitleLabel,
         todayPNLTitleLabel,
         currentValueLabel,
         totalInvestmentValueLabel].forEach { label in
            label.font = .systemFont(ofSize: 16, weight: .light)
        }
        
        
        setStackViewProperties(for: [profitAndLossStackView,
                                     currentValueStackView,
                                     totalInvestmentStackView,
                                     todayPNLStackView])
        
        dividerView.backgroundColor = .systemGray
        dividerView.isHidden = true
        
        expandedContentStackView.axis = .vertical
        expandedContentStackView.spacing = 12
        expandedContentStackView.isHidden = true
    }
    
    private func setTranslatesAutoresizingMaskIntoConstraints(for views: [UIView]) {
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setStackViewProperties(for views: [UIStackView]) {
        views.forEach { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .fill
        }
    }
    
    private func layout() {
        addSubview(containerView)
        
        imageTitleContainer.addSubview(profitAndLossTitleLabel)
        imageTitleContainer.addSubview(iconImageView)
        
        profitAndLossStackView.addArrangedSubviews([imageTitleContainer, profitAndLossValueLabel])
        containerView.addArrangedSubview(profitAndLossStackView)
        
        currentValueStackView.addArrangedSubviews([currentValueTitleLabel, currentValueLabel])
        totalInvestmentStackView.addArrangedSubviews([totalInvestmentTitleLabel, totalInvestmentValueLabel])
        todayPNLStackView.addArrangedSubviews([todayPNLTitleLabel, todayPNLValueLabel])
        
        expandedContentStackView.addArrangedSubviews([currentValueStackView, totalInvestmentStackView, todayPNLStackView])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            containerView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: containerView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 3),
            
            profitAndLossTitleLabel.leadingAnchor.constraint(equalTo: imageTitleContainer.leadingAnchor),
            profitAndLossTitleLabel.topAnchor.constraint(equalTo: imageTitleContainer.topAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: profitAndLossTitleLabel.trailingAnchor, constant: 8),
            iconImageView.topAnchor.constraint(equalTo: imageTitleContainer.topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.centerYAnchor.constraint(equalTo: profitAndLossTitleLabel.centerYAnchor),
            
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
        containerView.insertArrangedSubview(expandedContentStackView, at: 0)
        containerView.insertArrangedSubview(dividerView, at: 1)
    }
}

// MARK: Add and Handle Tap Gesture
extension PortfolioSummaryDrawerView {
    private func setTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        profitAndLossStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        if isExpanded {
            isExpanded = false
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self else { return }
                self.iconImageView.transform = .identity
                self.expandedContentStackView.alpha = 0
                self.expandedContentStackView.isHidden = true
                self.dividerView.isHidden = true
                layoutIfNeeded()
            }
            
        } else {
            isExpanded = true
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self else { return }
                self.iconImageView.transform = CGAffineTransform(rotationAngle: .pi)
                self.expandedContentStackView.alpha = 1
                self.expandedContentStackView.isHidden = false
                self.dividerView.isHidden = false
                layoutIfNeeded()
            }
        }
    }
}

extension PortfolioSummaryDrawerView {
    func configure(with portfolio: StocksSummary) {
        profitAndLossValueLabel.textColor = portfolio.totalProfitNLoss.colorBasedOnMagnitude
        todayPNLValueLabel.textColor = portfolio.todaysTotalPNL.colorBasedOnMagnitude
        
        profitAndLossValueLabel.text = portfolio.totalProfitNLoss.withFormattedCurrency
        currentValueLabel.text = portfolio.currentValue.withFormattedCurrency
        totalInvestmentValueLabel.text = portfolio.totalInvestment.withFormattedCurrency
        todayPNLValueLabel.text = portfolio.todaysTotalPNL.withFormattedCurrency
    }
}


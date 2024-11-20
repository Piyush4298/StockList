//
//  StockTableViewCell.swift
//  StockList
//
//  Created by Piyush Pandey on 19/11/24.
//

import UIKit

final class StockTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: StockTableViewCell.self)
    private let containerView = UIView()
    private let symbolLabel = UILabel()
    private let quantityView = UIView()
    private let quantityTitleLabel = UILabel()
    private let quantityValueLabel = UILabel()
    private let lastTradedPriceView = UIView()
    private let lastTradedPriceTitleLabel = UILabel()
    private let lastTradedPriceValueLabel = UILabel()
    private let profitAndLossView = UIView()
    private let profitAndLossTitleLabel = UILabel()
    private let profitAndLossValueLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        quantityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        applySmallFont(to: quantityTitleLabel)
        quantityValueLabel.translatesAutoresizingMaskIntoConstraints = false
        applyLargeFont(to: quantityValueLabel)
        
        lastTradedPriceView.translatesAutoresizingMaskIntoConstraints = false
        lastTradedPriceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        applySmallFont(to: lastTradedPriceTitleLabel)
        lastTradedPriceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        applyLargeFont(to: lastTradedPriceValueLabel)
        
        profitAndLossView.translatesAutoresizingMaskIntoConstraints = false
        profitAndLossTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        applySmallFont(to: profitAndLossTitleLabel)
        profitAndLossValueLabel.translatesAutoresizingMaskIntoConstraints = false
        applyLargeFont(to: profitAndLossValueLabel)
        
        quantityTitleLabel.text = "NET QTY:"
        lastTradedPriceTitleLabel.text = "LTP:"
        profitAndLossTitleLabel.text = "P&L:"
    }
    
    private func setLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(symbolLabel)
        
        quantityView.addSubview(quantityTitleLabel)
        quantityView.addSubview(quantityValueLabel)
        containerView.addSubview(quantityView)
        
        lastTradedPriceView.addSubview(lastTradedPriceTitleLabel)
        lastTradedPriceView.addSubview(lastTradedPriceValueLabel)
        containerView.addSubview(lastTradedPriceView)
        
        profitAndLossView.addSubview(profitAndLossTitleLabel)
        profitAndLossView.addSubview(profitAndLossValueLabel)
        containerView.addSubview(profitAndLossView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            containerView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: containerView.trailingAnchor, multiplier: 2),
            
            symbolLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            lastTradedPriceTitleLabel.leadingAnchor.constraint(equalTo: lastTradedPriceView.leadingAnchor),
            lastTradedPriceValueLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: lastTradedPriceTitleLabel.trailingAnchor, multiplier: 1),
            lastTradedPriceTitleLabel.centerYAnchor.constraint(equalTo: lastTradedPriceValueLabel.centerYAnchor),
            lastTradedPriceView.trailingAnchor.constraint(equalTo: lastTradedPriceValueLabel.trailingAnchor),
            lastTradedPriceView.topAnchor.constraint(equalTo: symbolLabel.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: lastTradedPriceView.trailingAnchor),
            
            quantityView.topAnchor.constraint(equalToSystemSpacingBelow: symbolLabel.bottomAnchor, multiplier: 4),
            quantityTitleLabel.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor),
            quantityValueLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: quantityTitleLabel.trailingAnchor, multiplier: 1),
            quantityTitleLabel.centerYAnchor.constraint(equalTo: quantityValueLabel.centerYAnchor),
            quantityView.trailingAnchor.constraint(equalTo: quantityValueLabel.trailingAnchor),
            quantityView.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            
            profitAndLossTitleLabel.leadingAnchor.constraint(equalTo: profitAndLossView.leadingAnchor),
            profitAndLossValueLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: profitAndLossTitleLabel.trailingAnchor, multiplier: 1),
            profitAndLossTitleLabel.centerYAnchor.constraint(equalTo: profitAndLossValueLabel.centerYAnchor),
            profitAndLossView.trailingAnchor.constraint(equalTo: profitAndLossValueLabel.trailingAnchor),
            profitAndLossView.centerYAnchor.constraint(equalTo: quantityView.centerYAnchor),
            profitAndLossView.trailingAnchor.constraint(equalTo: lastTradedPriceView.trailingAnchor)
        ])
    }
    
    private func applySmallFont(to label: UILabel) {
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
    }
    
    private func applyLargeFont(to label: UILabel) {
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
    }
}

extension StockTableViewCell {
    func configure(with stock: Stock) {
        symbolLabel.text = stock.symbol
        quantityValueLabel.text = "\(stock.quantity)"
        lastTradedPriceValueLabel.text = stock.ltp.withFormattedCurrency
        profitAndLossValueLabel.text = calculateProfitOrLoss(stock.quantity, stock.ltp, stock.close)
    }
    
    private func calculateProfitOrLoss(_ qty: Int,_ lastTradedPrice: Double,_ closingPrice: Double) -> String {
        let calc = (closingPrice - lastTradedPrice) * Double(qty)
        profitAndLossValueLabel.textColor = calc.colorBasedOnMagnitude
        return calc.withFormattedCurrency
    }
}

//
//  ShimmerLoadTableViewCell.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import UIKit

final class ShimmerLoadTableViewCell: UITableViewCell {
    static let identifier = String(describing: ShimmerLoadTableViewCell.self)
    
    private let containerView = UIView()
    private let symbolShimmer = ShimmerView()
    private let quantityShimmer = ShimmerView()
    private let ltpShimmer = ShimmerView()
    private let plShimmer = ShimmerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        symbolShimmer.translatesAutoresizingMaskIntoConstraints = false
        quantityShimmer.translatesAutoresizingMaskIntoConstraints = false
        ltpShimmer.translatesAutoresizingMaskIntoConstraints = false
        plShimmer.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        containerView.addSubview(symbolShimmer)
        containerView.addSubview(quantityShimmer)
        containerView.addSubview(ltpShimmer)
        containerView.addSubview(plShimmer)
        
        symbolShimmer.layer.cornerRadius = 4
        quantityShimmer.layer.cornerRadius = 4
        ltpShimmer.layer.cornerRadius = 4
        plShimmer.layer.cornerRadius = 4
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            containerView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: containerView.trailingAnchor, multiplier: 2),
            
            // Symbol shimmer
            symbolShimmer.topAnchor.constraint(equalTo: containerView.topAnchor),
            symbolShimmer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            symbolShimmer.widthAnchor.constraint(equalToConstant: 100),
            symbolShimmer.heightAnchor.constraint(equalToConstant: 24),
            
            // LTP shimmer
            ltpShimmer.topAnchor.constraint(equalTo: containerView.topAnchor),
            ltpShimmer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            ltpShimmer.widthAnchor.constraint(equalToConstant: 80),
            ltpShimmer.heightAnchor.constraint(equalToConstant: 24),
            
            // Quantity shimmer
            quantityShimmer.topAnchor.constraint(equalToSystemSpacingBelow: symbolShimmer.bottomAnchor, multiplier: 4),
            quantityShimmer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            quantityShimmer.widthAnchor.constraint(equalToConstant: 60),
            quantityShimmer.heightAnchor.constraint(equalToConstant: 20),
            
            // P&L shimmer
            plShimmer.centerYAnchor.constraint(equalTo: quantityShimmer.centerYAnchor),
            plShimmer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            plShimmer.widthAnchor.constraint(equalToConstant: 80),
            plShimmer.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

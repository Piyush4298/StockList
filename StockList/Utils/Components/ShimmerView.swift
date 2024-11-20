//
//  ShimmerView.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import UIKit

final class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let animationDuration: CFTimeInterval = 1.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupShimmer() {
        backgroundColor = .systemGray6
        
        // Gradient for shimmer effect
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [
            UIColor.systemGray6.cgColor,
            UIColor.systemGray5.cgColor,
            UIColor.systemGray6.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        layer.addSublayer(gradientLayer)
        startAnimating()
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = animationDuration
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }
}

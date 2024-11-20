//
//  UIStackView+Extension.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}

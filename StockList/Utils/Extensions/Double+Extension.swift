//
//  Double+Extension.swift
//  StockList
//
//  Created by Piyush Pandey on 19/11/24.
//

import Foundation
import UIKit

extension Double {
    
    var withFormattedCurrency: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = .current
        numberFormatter.currencyCode = "INR"
        return numberFormatter.string(from: NSDecimalNumber(floatLiteral: self)) ?? "Rs.\(self)"
    }
    
    var colorBasedOnMagnitude: UIColor {
        if self < 0 {
            return UIColor.systemRed
        } else {
            return UIColor.systemGreen
        }
    }
}

//
//  UILabel+Extension.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import Foundation
import UIKit

extension UILabel {
    func colorBasedOnMagnitude(_ value: Double) {
        if value < 0 {
            self.textColor = .systemRed
        } else {
            self.textColor = .systemGreen
        }
    }
    
    func setTextWithSuperscript(text: String, superscriptText: String) {
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: self.font as Any,
            .foregroundColor: self.textColor as Any
        ]
        
        let superscriptAttributes: [NSAttributedString.Key: Any] = [
            .font: self.font as Any,
            .baselineOffset: 4,
            .foregroundColor: self.textColor as Any
        ]
        
        let normalString = NSAttributedString(string: text, attributes: normalAttributes)
        let superscriptString = NSAttributedString(string: superscriptText, attributes: superscriptAttributes)
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(normalString)
        combinedString.append(superscriptString)
        
        self.attributedText = combinedString
    }
}

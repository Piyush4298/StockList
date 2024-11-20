//
//  AlertPresenter.swift
//  StockList
//
//  Created by Piyush Pandey on 20/11/24.
//

import Foundation
import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showError(_ error: BaseErrorType, retryAction: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Error",
            message: error.errorDescription,
            preferredStyle: .alert
        )
        
        if let retry = retryAction {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                retry()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        DispatchQueue.main.async { [weak viewController] in
            viewController?.present(alert, animated: true)
        }
    }
}

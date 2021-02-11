//
//  UIViewController+Ext.swift
//  GBShop
//
//  Created by Maxim Safronov on 15.12.2020.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorMessage(message: String, title: String? = "Ошибка", handler: ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: handler)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}

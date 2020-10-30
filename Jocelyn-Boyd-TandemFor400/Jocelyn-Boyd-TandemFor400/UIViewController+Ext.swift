//
//  UIViewController+Ext.swift
//  Jocelyn-Boyd-TandemFor400
//
//  Created by Jocelyn Boyd on 10/29/20.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, action: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let nextQuestionAction = UIAlertAction(title: "Next", style: .default) { (_) in
            action?()
        }
        alert.addAction(nextQuestionAction)
        present(alert, animated: true)
    }
}

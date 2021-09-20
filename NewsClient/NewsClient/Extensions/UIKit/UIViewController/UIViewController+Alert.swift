//
//  AlertManager.swift
//  NewsClient
//
//  Created by Admin on 16.09.21.
//

import UIKit

extension UIViewController {

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

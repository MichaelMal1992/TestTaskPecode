//
//  ViewControllersFactory.swift
//  NewsClient
//
//  Created by Admin on 14.09.21.
//

import UIKit

class ViewControllersFactory {

    static func create(_ name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: name)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}

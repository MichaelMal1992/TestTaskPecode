//
//  WebViewController.swift
//  NewsClient
//
//  Created by Admin on 14.09.21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    static let identifier = String(describing: WebViewController.self)

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }

    private func setupWebView() {
        webView.navigationDelegate = self
        guard let link = UserDefaults.standard.value(forKey: "urlForWebView") as? String else {
            return
        }
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

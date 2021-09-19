//
//  SourcesViewController.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class SourcesViewController: UIViewController {

    @IBOutlet weak var sourcesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var sourcesArray: [String] = [] {
        didSet {
            sourcesTableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }

    static let identifier = String(describing: SourcesViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        HTTPClient.shared.fetchAvailableNewsSources { [weak self] results in
            guard let self = self else {
                return
            }
            switch results {
            case .success(let sources):
                if sources.status == "ok" {
                    var array: [String] = []
                    for value in sources.sources {
                        array.append(value.source)
                    }
                    let uniqueArray = Array(Set(array))
                    self.sourcesArray = uniqueArray.sorted()
                } else {
                    self.showAlert("Error")
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                self.showAlert("Error")
                self.activityIndicator.stopAnimating()
                print(error.localizedDescription)
            }
        }
    }

    func setupTableView() {
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
    }

}

extension SourcesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sourcesArray[indexPath.row].uppercased().replacingOccurrences(of: "-", with: " ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valueToSave = sourcesArray[indexPath.row]
        UserDefaults.standard.setValue("sources=\(valueToSave)", forKey: "topHeadlines")
        let newsViewController = ViewControllersFactory.create(NewsViewController.identifier) as? NewsViewController
        newsViewController?.loadRequest({ news in
            newsViewController?.newsData = news
        })
        navigationController?.popToRootViewController(animated: true)
    }
}

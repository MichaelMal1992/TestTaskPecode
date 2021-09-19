//
//  TableViewController.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categoriesArray: [String] = [] {
        didSet {
            categoryTableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
    static let identifier = String(describing: CategoryViewController.self)

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
                        array.append(value.category)
                    }
                    let uniqueArray = Array(Set(array))
                    self.categoriesArray = uniqueArray.sorted()
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
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categoriesArray[indexPath.row].capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valueToSave = categoriesArray[indexPath.row]
        UserDefaults.standard.setValue("category=\(valueToSave)", forKey: "topHeadlines")
        let newsViewController = ViewControllersFactory.create(NewsViewController.identifier) as? NewsViewController
        newsViewController?.loadRequest({ news in
            newsViewController?.newsData = news
        })
        navigationController?.popToRootViewController(animated: true)
    }
}

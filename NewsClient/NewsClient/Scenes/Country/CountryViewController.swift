//
//  CountryViewController.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class CountryViewController: UIViewController {

    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var countriesArray: [String] = [] {
        didSet {
            countryTableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }

    static let identifier = String(describing: CountryViewController.self)

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
                        array.append(value.country)
                    }
                    let uniqueArray = Array(Set(array))
                    self.countriesArray = uniqueArray.sorted()
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
        countryTableView.delegate = self
        countryTableView.dataSource = self
    }

}

extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = countriesArray[indexPath.row].uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let valueToSave = countriesArray[indexPath.row]
        UserDefaults.standard.setValue("country=\(valueToSave)", forKey: "topHeadlines")
        let newsViewController = ViewControllersFactory.create(NewsViewController.identifier) as? NewsViewController
        newsViewController?.loadRequest({ news in
            newsViewController?.newsData = news
        })
        navigationController?.popToRootViewController(animated: true)
    }
}

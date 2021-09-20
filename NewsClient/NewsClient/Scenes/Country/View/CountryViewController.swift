//
//  CountryViewController.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class CountryViewController: UIViewController {

    static let identifier = String(describing: CountryViewController.self)
    
    @IBOutlet
    weak var countryTableView: UITableView!
    @IBOutlet
    weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: CountryViewModel?
    
    private var countriesArray: [String] = [] {
        didSet {
            countryTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = CountryViewModelImplementation(self)
        viewModel?.loadSources{ [weak self] array in
            self?.countriesArray = array
        }
    }

    private func setupTableView() {
        countryTableView.delegate = self
        countryTableView.dataSource = self
    }

}

// TableView delegats
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
        FiltersValue.shared.filter = "country=\(valueToSave)"
        navigationController?.popToRootViewController(animated: true)
    }
}

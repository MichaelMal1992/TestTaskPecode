//
//  TableViewController.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class CategoryViewController: UIViewController {

    static let identifier = String(describing: CategoryViewController.self)

    @IBOutlet
    weak var categoryTableView: UITableView!
    @IBOutlet
    weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: CategoryViewModel?
    
    private var categoriesArray: [String] = [] {
        didSet {
            categoryTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = CategoryViewModelImplementation(self)
        viewModel?.loadSources{ [weak self] array in
            self?.categoriesArray = array
        }
    }

    private func setupTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
}

// TableView delegats
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
        FiltersValue.shared.filter = "category=\(valueToSave)"
        navigationController?.popToRootViewController(animated: true)
    }
}

//
//  SourcesViewController.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class SourcesViewController: UIViewController {

    static let identifier = String(describing: SourcesViewController.self)

    @IBOutlet
    weak var sourcesTableView: UITableView!
    @IBOutlet
    weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: SourcesViewModel?
    
    private var sourcesArray: [String] = [] {
        didSet {
            sourcesTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = SourcesViewModelImplementation(self)
        viewModel?.loadSources{ [ weak self ] array in
            self?.sourcesArray = array
        }
        
    }

    func setupTableView() {
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
    }

}

// TableView delegats
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
        FiltersValue.shared.filter = "sources=\(valueToSave)"
        navigationController?.popToRootViewController(animated: true)
    }
}

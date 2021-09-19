//
//  FilterNewsViewController.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import UIKit

class FilterNewsViewController: UIViewController {

    @IBOutlet weak var filterTableView: UITableView!
    
    static let identifier = String(describing: FilterNewsViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        let nib = UINib(nibName: FilterNewsTableViewCell.identifier, bundle: nil)
        let identifier = FilterNewsTableViewCell.identifier
        filterTableView.register(nib, forCellReuseIdentifier: identifier)
        filterTableView.delegate = self
        filterTableView.dataSource = self
    }
}

extension FilterNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filterTableView.dequeueReusableCell(withIdentifier: FilterNewsTableViewCell.identifier, for: indexPath) as? FilterNewsTableViewCell else {
            return UITableViewCell()
        }
        cell.nameFilteringLabel.text = FilterList.allCases[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch FilterList.allCases[indexPath.row] {
        case .category:
            let  categoryViewController = ViewControllersFactory.create(CategoryViewController.identifier)
            navigationController?.pushViewController(categoryViewController, animated: true)
            
        case .country:
            let  countryViewController = ViewControllersFactory.create(CountryViewController.identifier)
            navigationController?.pushViewController(countryViewController, animated: true)
        case .sources:
            let  sourcesViewController = ViewControllersFactory.create(SourcesViewController.identifier)
            navigationController?.pushViewController(sourcesViewController, animated: true)
        }
    }
}

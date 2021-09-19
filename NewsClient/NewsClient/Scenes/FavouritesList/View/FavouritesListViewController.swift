//
//  FavouritesListViewController.swift
//  NewsClient
//
//  Created by Admin on 14.09.21.
//

import UIKit

class FavouritesListViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = String(describing: FavouritesListViewController.self)
    
    var favouritesNewsData: [FavouritesNewsData] = []

    var imagesArrayData: [ImageData] = [] {
        didSet {
            favouritesTableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBarButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesNewsData = RealmManager.shared.getAll.sorted(by: {$0.publishedAt > $1.publishedAt})
        loadImage()
    }

    func loadImage() {
        var strings: [String] = []
        for string in favouritesNewsData {
            if string.urlToImage.isEmpty == false {
                strings.append(string.urlToImage)
            }
        }
        HTTPClient.shared.downloadImage(strings) { [weak self] results in
            switch results {
            case .success(let data):
                self?.imagesArrayData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setupBarButtonItem() {
        let trashBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonPressed(_:)))
        navigationItem.rightBarButtonItem = trashBarButtonItem
        
    }
    func setupTableView() {
        let nib = UINib(nibName: FavouritesListTableViewCell.identifier, bundle: nil)
        let identifier = FavouritesListTableViewCell.identifier
        favouritesTableView.register(nib, forCellReuseIdentifier: identifier)
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
    }

    @objc func trashBarButtonPressed(_ sender: UIBarButtonItem) {
        RealmManager.shared.deleteAll()
        favouritesNewsData.removeAll()
        favouritesTableView.reloadData()
    }
}



extension FavouritesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesNewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favouritesTableView.dequeueReusableCell(withIdentifier: FavouritesListTableViewCell.identifier, for: indexPath) as? FavouritesListTableViewCell else {
            return UITableViewCell()
        }
        let favouritesNews = favouritesNewsData[indexPath.row]
        cell.authorLabel.text = favouritesNews.author
        cell.descriptionLabel.text = favouritesNews.descriptions
        cell.publishedLabel.text = favouritesNews.publishedAt.prefix(19).replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
        cell.sourceLabel.text = favouritesNews.sourceName
        cell.titleLabel.text = favouritesNews.title
        cell.urlToImageLabel.text = favouritesNews.urlToImage
        cell.pictureImageView.image = imagesArrayData.first(where: { $0.name == favouritesNews.urlToImage })?.image ?? UIImage(named: "noImage_icon")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = favouritesNewsData[indexPath.row].url
        UserDefaults.standard.setValue(link, forKey: "urlForWebView")
        let webViewController = ViewControllersFactory.create(WebViewController.identifier)
        navigationController?.pushViewController(webViewController, animated: true)
        
    }
}

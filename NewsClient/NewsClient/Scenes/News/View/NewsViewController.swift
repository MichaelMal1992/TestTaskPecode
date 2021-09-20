//
//  ViewController.swift
//  NewsClient
//
//  Created by Admin on 14.09.21.
//

import UIKit

class NewsViewController: UIViewController {

    static let identifier = String(describing: NewsViewController.self)
    
    @IBOutlet
    weak var newsTableView: UITableView!
    @IBOutlet
    weak var filterBarButton: UIBarButtonItem!
    @IBOutlet
    weak var showFavouritesBarButton: UIBarButtonItem!
    @IBOutlet
    weak var searchTextField: UITextField!
    @IBOutlet
    weak var cancelKeyboardTextFieldButton: UIButton!
    @IBOutlet
    weak var activityIndicator: UIActivityIndicatorView!

    var refreshControl: UIRefreshControl?
    
    private var viewModel: NewsViewModel?
    
    var imagesData: [ImageData] = [] {
        didSet {
            newsTableView.reloadData()
        }
    }
    var newsData: NewsData? {
        didSet {
            newsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        setupTableView()
        setupTextField()
        setupButtons()
        viewModel = NewsViewModelImplementation.init(self)
        viewModel?.loadRequest(filters: "category=general") { [weak self ] newsData, imagesData in
            self?.newsData = newsData
            self?.imagesData = imagesData
        }
    }
    
    @IBAction
    private func filterBarButtonPressed(_ sender: UIBarButtonItem) {
        let filterNewsViewController = ViewControllersFactory.create(FilterNewsViewController.identifier)
        navigationController?.pushViewController(filterNewsViewController, animated: true)
    }
    
    @IBAction
    private func showFavouritesBarButtonPressed(_ sender: UIBarButtonItem) {
        let favouritesListViewController = ViewControllersFactory.create(FavouritesListViewController.identifier)
        navigationController?.pushViewController(favouritesListViewController, animated: true)
    }
    
    @IBAction
    private func cancelKeyboardTextFieldButtonPressed(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        sender.isHidden = true
    }
    
    @objc
    private func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel?.loadRequest(filters: "category=general") { [weak self ] newsData, imagesData in
            self?.newsData = newsData
            self?.imagesData = imagesData
        }
    }
    
    private func setupButtons() {
        cancelKeyboardTextFieldButton.isHidden = true
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: NewsTableViewCell.identifier, bundle: nil)
        let identifier = NewsTableViewCell.identifier
        newsTableView.register(nib, forCellReuseIdentifier: identifier)
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    
    private func setupTextField() {
        searchTextField.delegate = self
    }
}

// TableView delegats
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = newsData?.articles.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                           for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let articles = newsData?.articles[indexPath.row]
        cell.authorLabel.text = articles?.author
        cell.descriptionLabel.text = articles?.description
        cell.sourceLabel.text = articles?.source.name
        cell.titleLabel.text = articles?.title
        cell.urlToImageLabel.text = articles?.urlToImage
        cell.publishedLabel.text = articles?.publishedAt?.prefix(19).replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "")
        cell.pictureImageView.image = imagesData.first(where: { $0.name == articles?.urlToImage })?.image ?? UIImage(named: "noImage_icon")
        
        cell.handlerAddFavouritesButton = {
            let favouritesNewsData = FavouritesNewsData()
            let arrayfavouritesNews = RealmManager.shared.getAll
            favouritesNewsData.publishedAt = articles?.publishedAt ?? ""
            favouritesNewsData.author = articles?.author ?? ""
            favouritesNewsData.descriptions = articles?.description ?? ""
            favouritesNewsData.sourceName = articles?.source.name ?? ""
            favouritesNewsData.title = articles?.title ?? ""
            favouritesNewsData.urlToImage = articles?.urlToImage ?? ""
            favouritesNewsData.url = articles?.url ?? ""
            
            if (arrayfavouritesNews.first(where: { $0.url ==  favouritesNewsData.url }) != nil) {
                self.showAlert("Already to favourites")
            } else {
                RealmManager.shared.addNew(favouritesNewsData)
                self.showAlert("Add to favourites")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = newsData?.articles[indexPath.row].url
        UserDefaults.standard.setValue(link, forKey: "urlForWebView")
        let webViewController = ViewControllersFactory.create(WebViewController.identifier)
        navigationController?.pushViewController(webViewController, animated: true)
        
    }
}

// ScrollView delegats
extension NewsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let contentHeight = newsTableView.contentSize.height
        if position > contentHeight - height,
           newsData?.articles.isEmpty == false,
           viewModel?.isPagination == false {
            viewModel?.isPagination = true
            guard let isPagination = viewModel?.isPagination else {
                return
            }
            switch isPagination {
            case true:
                viewModel?.loadRequest(filters: "category=general") { [weak self ] newsData, imagesData in
                    self?.newsData = newsData
                    self?.imagesData = imagesData
                }
            case false:
                return
            }
        } else {
            return
        }
    }
}

// TextField delegats
extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        cancelKeyboardTextFieldButton.isHidden = true
        if let text = textField.text,
           text.isEmpty == false {
            viewModel?.loadRequest(filters: "q=\(text)") { [weak self ] newsData, imagesData in
                self?.newsData = newsData
                self?.imagesData = imagesData
            }
        } else {
            textField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelKeyboardTextFieldButton.isHidden = false
    }
}

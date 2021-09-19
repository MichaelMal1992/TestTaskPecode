//
//  ViewController.swift
//  NewsClient
//
//  Created by Admin on 14.09.21.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    @IBOutlet weak var showFavouritesBarButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelKeyboardTextFieldButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl?
    
    static let identifier = String(describing: NewsViewController.self)

    var page = 10
    
    var isPagination = false {
        didSet {
            if isPagination {
                loadRequest { [weak self] news in
                    guard let self = self else {
                        return
                    }
                    if self.page < news.totalResults ?? self.page {
                        self.page += 10
                        self.newsData = news
                    } else {
                        self.showAlert("This is all news")
                        return
                    }
                }
            }
        }
    }
    
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
        UserDefaults.standard.setValue("category=general", forKey: "topHeadlines")
        UserDefaults.standard.setValue(page, forKey: "pageSize")
        loadRequest { [weak self] news in
            self?.newsData = news
        }
    }
    
    @IBAction func filterBarButtonPressed(_ sender: UIBarButtonItem) {
        let filterNewsViewController = ViewControllersFactory.create(FilterNewsViewController.identifier)
        navigationController?.pushViewController(filterNewsViewController, animated: true)
    }
    
    @IBAction func showFavouritesBarButtonPressed(_ sender: UIBarButtonItem) {
        let favouritesListViewController = ViewControllersFactory.create(FavouritesListViewController.identifier)
        navigationController?.pushViewController(favouritesListViewController, animated: true)
    }
    
    
    @IBAction func cancelKeyboardTextFieldButtonPressed(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        sender.isHidden = true
    }
    
    func loadRequest(_ comletion: @escaping (NewsData) -> Void) {
        if refreshControl?.isRefreshing == false,
           activityIndicator.isAnimating == false {
            activityIndicator.startAnimating()
        }
        HTTPClient.shared.fetchAvailableNews(page: page) { [weak self] results, finishLoad  in
            switch results {
            case .success(let news):
                self?.activityIndicator.stopAnimating()
                self?.refreshControl?.endRefreshing()
                if news.status == "ok",
                   news.articles.isEmpty == false {
                    comletion(news)
                    self?.loadImage(news)
                    self?.isPagination = !finishLoad
                } else {
                    self?.showAlert("Nothing found about this")
                    UserDefaults.standard.setValue("category=general", forKey: "topHeadlines")
                }
            case .failure(let errror):
                self?.showAlert("Error")
                self?.activityIndicator.stopAnimating()
                self?.refreshControl?.endRefreshing()
                UserDefaults.standard.setValue("category=general", forKey: "topHeadlines")
                print(errror.localizedDescription)
            }
        }
    }
    
    func loadImage(_ newsData: NewsData) {
        var strings: [String] = []
        for articles in newsData.articles {
            if let string = articles.urlToImage,
               string.isEmpty == false,
               string.prefix(8) == "https://" || string.prefix(7) == "http://" {
                strings.append(string)
            }
        }
        HTTPClient.shared.downloadImage(strings) { [weak self] results in
            switch results {
            case .success(let imageData):
                self?.imagesData = imageData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadRequest { [weak self] news in
            self?.newsData = news
        }
    }
    
    func setupButtons() {
        cancelKeyboardTextFieldButton.isHidden = true
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        newsTableView.refreshControl = refreshControl
    }
    
    func setupTableView() {
        let nib = UINib(nibName: NewsTableViewCell.identifier, bundle: nil)
        let identifier = NewsTableViewCell.identifier
        newsTableView.register(nib, forCellReuseIdentifier: identifier)
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    
    func setupTextField() {
        searchTextField.delegate = self
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = newsData?.articles.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let contentHeight = newsTableView.contentSize.height
        if position > contentHeight - height,
           newsData?.articles.isEmpty == false,
           isPagination == false {
            isPagination = true
        } else {
            return
        }
    }
}

extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        cancelKeyboardTextFieldButton.isHidden = true
        if let text = textField.text,
           text.isEmpty == false {
            UserDefaults.standard.setValue("q=\(text)", forKey: "topHeadlines")
            self.loadRequest { [weak self] news in
                self?.newsData = news
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

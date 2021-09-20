//
//  FavouritesListViewModelImplementation.swift
//  NewsClient
//
//  Created by Admin on 20.09.21.
//

import Foundation

class FavouritesListViewModelImplementaion: FavouritesListViewModel {
    
    weak var viewController: FavouritesListViewController?
    init(_ viewController: FavouritesListViewController) {
        self.viewController = viewController
    }
    
    func loadImage(_ favouritesNewsData: [FavouritesNewsData], _ completion: @escaping ([ImageData]) -> Void) {
        var strings: [String] = []
        for string in favouritesNewsData {
            if string.urlToImage.isEmpty == false {
                strings.append(string.urlToImage)
            }
        }
        HTTPClient.shared.downloadImage(strings) { results in
            switch results {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

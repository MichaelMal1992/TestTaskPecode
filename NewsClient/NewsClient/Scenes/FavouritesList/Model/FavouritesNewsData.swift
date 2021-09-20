//
//  FavouritesNewsData.swift
//  NewsClient
//
//  Created by Admin on 16.09.21.
//

import Foundation
import RealmSwift

class FavouritesNewsData: Object {
    
    @Persisted var author: String
    @Persisted var descriptions: String
    @Persisted var sourceName: String
    @Persisted var title: String
    @Persisted var urlToImage: String
    @Persisted var publishedAt: String
    @Persisted var url: String
}

//
//  EnumFilterList.swift
//  NewsClient
//
//  Created by Admin on 15.09.21.
//

import Foundation

enum FilterList: CaseIterable {

    case category
    case country
    case sources

    var title: String {
        switch self {
        case .category:
            return "Category"
        case .country:
            return "Country"
        case .sources:
            return "Sources"
        }
    }
}

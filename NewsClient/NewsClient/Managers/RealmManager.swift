//
//  RealmManager.swift
//  NewsClient
//
//  Created by Admin on 16.09.21.
//

import Foundation
import RealmSwift

class RealmManager {

    static let shared = RealmManager()

    private let realm: Realm?

    private init() {
        do {
            self.realm = try Realm()
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
    }

    func addNew(_ object: FavouritesNewsData) {
        do {
            try realm?.write {
                realm?.add(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    var getAll: [FavouritesNewsData] {
        if let array = realm?.objects(FavouritesNewsData.self) {
            return Array(array)
        }
        return []
    }

    func write(_ completion: () -> Void) {
        do {
            try realm?.write {
                completion()
           }
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteAll() {
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

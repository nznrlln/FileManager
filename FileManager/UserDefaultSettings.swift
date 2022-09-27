//
//  UserDefaults.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 27.09.2022.
//

import Foundation

struct UserDefaultSettings {

    enum PasswordExists: Int {
        case existNot = 0
        case exist = 1
    }

    enum ListSorting: Int {
        case alphabet = 0
        case reverseAlphabed = 1
    }

    static var passwordState: PasswordExists {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "PasswordState")
            UserDefaults.standard.synchronize()
        }
        get {
            return PasswordExists(rawValue: UserDefaults.standard.integer(forKey: "PasswordState")) ?? .existNot
        }
    }

    static var sorting: ListSorting {
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "ListSorting")
            UserDefaults.standard.synchronize()
        }
        get {
            return ListSorting(rawValue: UserDefaults.standard.integer(forKey: "ListSorting")) ?? .alphabet
        }
    }

    static var service: String = "niyaz.FileManager"
    static var username: String = "test"
}

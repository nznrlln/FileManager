//
//  KeyChain.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 22.09.2022.
//

import Foundation

//class KeyChain {
//
//    static func addPassword(login: String, password: String, serviceName: String) {
//
//        guard let passData = password.data(using: .utf8) else {
//            print("Ошибка преобразования пароля")
//            return
//        }
//
//        let attribute = [
//            kSecClass: kSecClassGenericPassword,
//            kSecValueData: passData,
//            kSecAttrAccount: login,
//            kSecAttrService: serviceName,
//            //kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
//        ] as CFDictionary
//
//        let status = SecItemAdd(attribute, nil)
//
//        if status == errSecSuccess {
//            print("Пароль добавлен")
//        } else {
//            print("Ошибка добавления пароля: \(status)")
//        }
//    }
//
//
//    static func getPassword(login: String, serviceName: String) -> String? {
//        let  query = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrAccount: login,
//            kSecAttrService: serviceName,
//            kSecReturnData: true
//        ] as CFDictionary
//
//        var extractedData: AnyObject?
//
//        let status = SecItemCopyMatching(query, &extractedData)
//
//        if status != errSecSuccess {
//            print("Ошибка получения пароля: \(status)")
//            return nil
//        }
//
//        guard let passData = extractedData as? Data,
//              let password = String(data: passData, encoding: .utf8) else {
//            print("Ошибка преобразования пароля")
//            return nil
//        }
//
//        return password
//    }
//
//
//    static func updatePassword(login: String, newPassword: String, serviceName: String) {
//
//        guard let passData = newPassword.data(using: .utf8) else {
//            print("Ошибка преобразования пароля")
//            return
//        }
//
//        let query = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrAccount: login,
//            kSecAttrService: serviceName,
//            kSecReturnData: false
//        ] as CFDictionary
//
//        let attribute = [
//            kSecValueData: passData
//        ] as CFDictionary
//
//        let status = SecItemUpdate(query, attribute)
//
//        if status == errSecSuccess {
//            print("Пароль обновлен")
//        } else {
//            print("Ошибка обновления пароля: \(status)")
//        }
//    }
//
//
//    static func deletePassword(login: String, serviceName: String) {
//        let query = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrAccount: login,
//            kSecAttrService: serviceName,
//            kSecReturnData: false
//        ] as CFDictionary
//
//        let status = SecItemDelete(query)
//
//        if status == errSecSuccess {
//            print("Пароль успешно удален")
//        } else {
//            print("Пароль не удален, ошибка: \(status)")
//        }
//    }
//
//
//}


class KeyChain {

    static func addPassword(login: String, password: String, serviceName: String) {

        guard let passData = password.data(using: .utf8) else {
            print("Ошибка преобразования пароля")
            return
        }

        let attribute = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
            kSecAttrAccount: login,
            kSecAttrService: serviceName,
            //kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ] as CFDictionary

        let status = SecItemAdd(attribute, nil)

        if status == errSecSuccess {
            print("Пароль добавлен")
        } else {
            print("Ошибка добавления пароля: \(status)")
        }
    }


    static func getPassword(login: String, serviceName: String) -> String? {
        let  query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecAttrService: serviceName,
            kSecReturnData: true
        ] as CFDictionary

        var extractedData: AnyObject?

        let status = SecItemCopyMatching(query, &extractedData)

        if status != errSecSuccess {
            print("Ошибка получения пароля: \(status)")
            return nil
        }

        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            print("Ошибка преобразования пароля")
            return nil
        }

        return password
    }


    static func updatePassword(login: String, newPassword: String, serviceName: String) {

        guard let passData = newPassword.data(using: .utf8) else {
            print("Ошибка преобразования пароля")
            return
        }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecAttrService: serviceName,
            kSecReturnData: false
        ] as CFDictionary

        let attribute = [
            kSecValueData: passData
        ] as CFDictionary

        let status = SecItemUpdate(query, attribute)

        if status == errSecSuccess {
            print("Пароль обновлен")
        } else {
            print("Ошибка обновления пароля: \(status)")
        }
    }


    static func deletePassword(login: String, serviceName: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: login,
            kSecAttrService: serviceName,
            kSecReturnData: false
        ] as CFDictionary

        let status = SecItemDelete(query)

        if status == errSecSuccess {
            print("Пароль успешно удален")
        } else {
            print("Пароль не удален, ошибка: \(status)")
        }
    }


}

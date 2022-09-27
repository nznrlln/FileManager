//
//  AppErrors.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 24.09.2022.
//

import Foundation

enum AppErrors: Error {
    case emptyPassword
    case shortPassword
    case mismatchPassword

    var description: String {
        switch self {
        case .emptyPassword:
            return "Пароль не может быть пустым!"
        case .shortPassword:
            return "Пароль должен состоять минимум из четырёх символов!"
        case .mismatchPassword:
            return "Пароль неверный!"
        default:
            return "Неизвестная ошибка."
        }
    }
}

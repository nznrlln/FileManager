//
//  UIView+Extension.swift
//  FileManager
//
//  Created by Нияз Нуруллин on 18.09.2022.
//

import Foundation
import UIKit

extension UIView {
    static var identifier: String {
        String(describing: self)
    }

    func toAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ subViews: UIView...) {
        subViews.forEach { addSubview($0) }
    }
}

//
//  UITableView+Extensions.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation
import UIKit

extension UITableView {

    public func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}

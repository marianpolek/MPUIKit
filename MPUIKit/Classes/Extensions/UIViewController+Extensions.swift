//
//  UIViewController+Extensions.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    public func showSnackBar(with text: String,
                             viewSkin: UIView.Skin = .whiteFlat(),
                             titleSkin: UILabel.Skin = .black16(),
                             insets: UIEdgeInsets = .all20,
                             image: UIImage? = UIImage.init(systemName: "info.circle"),
                             bottomSpace: CGFloat = 0) {
        
        let snackBarStartingPosition = UIScreen.main.bounds.maxY
        let snackBarHeight: CGFloat = 56

        if self.view.containsType(class: UniSnackBar.self) != nil { return }

        let snackBarWidth = UIScreen.main.bounds.width - insets.left - insets.right
        
        let snackBar =
        UniSnackBar(
            frame:
            CGRect(
                x: insets.left,
                y: snackBarStartingPosition,
                width: snackBarWidth,
                height: snackBarHeight
            ), 
            viewSkin: viewSkin,
            titleSkin: titleSkin,
            snackBarBottomSpace: insets.bottom
        )
        snackBar.text = text
        snackBar.leftImage(image: image)

        self.view.addSubview(snackBar)
        snackBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: snackBar, 
                           attribute: .leading,
                           relatedBy: .equal, 
                           toItem: self.view,
                           attribute: .leading,
                           multiplier: 1,
                           constant: insets.left).isActive = true
        
        NSLayoutConstraint(item: self.view, 
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: snackBar,
                           attribute: .trailing,
                           multiplier: 1,
                           constant: insets.right).isActive = true
        
        NSLayoutConstraint(item: self.view, 
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: snackBar,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: insets.bottom + bottomSpace).isActive = true
        
        NSLayoutConstraint(item: snackBar,
                           attribute: .top,
                           relatedBy: .greaterThanOrEqual,
                           toItem: self.view,
                           attribute: .top,
                           multiplier: 1,
                           constant: 10).isActive = true
    }
}

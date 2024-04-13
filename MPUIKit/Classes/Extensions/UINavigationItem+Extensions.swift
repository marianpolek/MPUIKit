//
//  UINavigationItem+Extensions.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation
import UIKit

public extension UINavigationItem {
    
    var titleImage: UIImageView? {
        get {
            return titleView as? UIImageView
        }
        set {
            title = nil
            self.titleView = newValue
        }
    }
    
    func setBackButtonItem(buttonView: UIView) {
        let customLeftButton = UIBarButtonItem()
        customLeftButton.customView = buttonView
        leftBarButtonItem = customLeftButton
    }
    
    func setRightButtonItem(buttonView: UIView) {
        let customRightButton = UIBarButtonItem()
        customRightButton.customView = buttonView
        rightBarButtonItem = customRightButton
    }
    
    func setRightButtonItems(_ buttonViews: [UIView], animated: Bool = false) {
        let buttons: [UIBarButtonItem] = buttonViews.map({ (btnView) -> UIBarButtonItem in
            let customRightButton = UIBarButtonItem()
            customRightButton.customView = btnView
            return customRightButton
        })
        self.setRightBarButtonItems(buttons, animated: animated)
    }
    
    func setLeftButtonItems(_ buttonViews: [UIView], animated: Bool = false) {
        let buttons: [UIBarButtonItem] = buttonViews.map({ (btnView) -> UIBarButtonItem in
            let customRightButton = UIBarButtonItem()
            customRightButton.customView = btnView
            return customRightButton
        })
        self.setLeftBarButtonItems(buttons, animated: animated)
    }
    
    enum ButtonColorStyle {
        case dark
        case gray
        case light
    }
    
    enum NavButtonType {
        case backButton(ButtonColorStyle)
        case close(ButtonColorStyle)
        case icon(String)
        case image(String)
        case plainApple(String)
        case dropDown(String, String)
        case customView(UIView)
        case empty
    }
    
    enum NavButtonPosition {
        case left
        case right
        case middle
    }
    
    struct NavButtonModel {
        
        var type: NavButtonType
        var position: NavButtonPosition
        var accessibilityString: String? = nil
        var tapAction: (() -> Void)? = nil
        var completionBlock: ((UIButton) -> Void)? = nil
        
        public init(type: NavButtonType,
                    position: NavButtonPosition,
                    accessibilityString: String? = nil,
                    tapAction: ( () -> Void)? = nil,
                    completionBlock: ( (UIButton) -> Void)? = nil) {
            self.type = type
            self.position = position
            self.accessibilityString = accessibilityString
            self.tapAction = tapAction
            self.completionBlock = completionBlock
        }
    }
    
    func setNavButtons(models: [NavButtonModel]) {

        for position in [.left, .middle, .right] as [NavButtonPosition] {
            models
                .filter({ $0.position == position })
                .handleModels { views in
                    switch position {
                    case .left: self.setLeftButtonItems(views)
                    case .middle: break
                    case .right: self.setRightButtonItems(views)
                    }
                    
                } justOne: { model in
                    self.setNavButton(type: model.type,
                                      position: model.position,
                                      accessibilityString: model.accessibilityString,
                                      tapAction: model.tapAction,
                                      completionBlock: model.completionBlock)
                }
        }
    }
    
    func setNavButton(type: NavButtonType,
                      position: NavButtonPosition,
                      accessibilityString: String? = nil,
                      tapAction: (() -> Void)? = nil,
                      completionBlock: ((UIButton) -> Void)? = nil) {
        
        
        let finalView: UIView = UINavigationItem
                                .navButtonBy(type: type,
                                            tapAction: tapAction,
                                            completionBlock: completionBlock)
        
        if let accessibilityString = accessibilityString {
            finalView.isAccessibilityElement = true
            finalView.accessibilityLabel = accessibilityString
        }
        
        switch position {
        case .left:
            self.setBackButtonItem(buttonView: finalView)
            
            if case .backButton = type {
                finalView.addConstraint(finalView.widthAnchor.constraint(equalToConstant: 44))
            }
        case .right:
            self.setRightButtonItem(buttonView: finalView)
        case .middle:
            self.titleView = finalView
        }
    }
    
    static func navButtonBy(type: NavButtonType,
                             tapAction: (() -> Void)? = nil,
                             completionBlock: ((UIButton) -> Void)? = nil) -> UIView {
        
        var finalView: UIView = UIView()
        
        switch type {
        case .customView(let view):
            finalView = view
        case .backButton(let style):
            let button = UIButton(type: .custom)
            button.setImage(UIImage.init(systemName: "arrow.backward"), for: .normal)
            finalView = button
            if let cb = completionBlock { cb(button) }
        case .close(let style):
            let button = UIButton(type: .close)
            finalView = button
            if let cb = completionBlock { cb(button) }
        case .empty:
            break
        default: break
        }
    
        return finalView
    }
}

public extension Array where Element == UINavigationItem.NavButtonModel {
    
    func handleModels(moreThenOne: (([UIView]) -> ()),
                        justOne: ((UINavigationItem.NavButtonModel) -> ())) {
        
        if self.count > 1 {
            let leftViews: [UIView] = self.map({ model in
                
                let finalView: UIView = UINavigationItem
                    .navButtonBy(type: model.type,
                                 tapAction: model.tapAction,
                                 completionBlock: model.completionBlock)
                
                if let accessibilityString = model.accessibilityString {
                    finalView.isAccessibilityElement = true
                    finalView.accessibilityLabel = accessibilityString
                }
                return finalView
            })
            moreThenOne(leftViews)
        } else if self.count == 1, let model = self.first {
            justOne(model)
        }
    }
}

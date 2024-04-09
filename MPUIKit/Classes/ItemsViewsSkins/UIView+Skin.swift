//
//  UIView+Skin.swift
//  MPUIKit
//
//  Created by Marian Polek on 09/04/2024.
//

import UIKit

public extension UIView {
    
    struct Skin {
        
        public var backgroundColor: UIColor = UIColor.clear
        public var cornerRadius: CGFloat = 0
        public var masksToBounds: Bool = false
        public var borderWidth: CGFloat = 0
        public var borderColor: UIColor = .black
        
        public init(
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            masksToBounds: Bool = false,
            borderWidth: CGFloat = 0,
            borderColor: UIColor = .black
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.masksToBounds = masksToBounds
            self.borderWidth = borderWidth
            self.borderColor = borderColor
        }
    }
    
    func apply(skin: UIView.Skin) {
        self.backgroundColor = skin.backgroundColor
        self.layer.cornerRadius = skin.cornerRadius
        self.layer.masksToBounds = skin.masksToBounds
        self.layer.borderWidth = skin.borderWidth
        self.layer.borderColor = skin.borderColor.cgColor
    }
}

public extension UIView.Skin {
    typealias Skin = UIView.Skin
    typealias Provider = () -> Skin
    
    static var `default`: Provider = {
        return Skin(backgroundColor: UIColor.clear,
                    cornerRadius: 5,
                    masksToBounds: false)
    }
    
    static var clear: Provider = {
        return UIView.Skin(backgroundColor: .clear, cornerRadius: 0)
    }
    
    static var whiteFlat: Provider = {
        return UIView.Skin(backgroundColor: .white)
    }
    
    static var whiteCorner10: Provider = {
        return UIView.Skin(backgroundColor: .white, cornerRadius: 10)
    }
    
    static var blackCorner10: Provider = {
        return UIView.Skin(backgroundColor: .black, cornerRadius: 10)
    }
}

//
//  UILabel+Skin.swift
//  MPUIKit
//
//  Created by Marian Polek on 09/04/2024.
//


import UIKit

public extension UILabel {
    
    struct Skin {
        public var font: UIFont
        public var tagFont: UIFont?
        public var backgroundColor: UIColor = UIColor.clear
        public var textColor: UIColor
        public var lineHeight: CGFloat?
        public var kern: CGFloat?
        
        public init(font: UIFont,
                    tagFont: UIFont? = nil,
                    backgroundColor: UIColor = UIColor.clear,
                    textColor: UIColor,
                    lineHeight: CGFloat? = nil,
                    kern: CGFloat? = nil) {
            self.font = font
            self.tagFont = tagFont
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.lineHeight = lineHeight
            self.kern = kern
        }
    }
    
    func apply(skin: UILabel.Skin, customAttributedFormatting: Bool = true) {
        self.font = skin.font
        self.backgroundColor = skin.backgroundColor
        self.textColor = skin.textColor
        
        if customAttributedFormatting == true,
           let lineHeight = skin.lineHeight,
           let kern = skin.kern,
           let text = text {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeight
            attributedText = NSMutableAttributedString(
                string: text,
                attributes: [
                    NSAttributedString.Key.kern: kern,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: skin.font
                ]
            )
            textAlignment = .center
        }
    }
}

public extension UILabel.Skin {
    typealias Skin = UILabel.Skin
    typealias Provider = () -> Skin
    
    static var `default`: Provider = {
        return Skin(font: UIFont.systemFont(ofSize: 16),
                    textColor: .black)
    }
    
    static var white16 : Provider = {
        return Skin(font: UIFont.systemFont(ofSize: 16),
                    textColor: .white)
    }
    
    static var black16 : Provider = {
        return Skin(font: UIFont.systemFont(ofSize: 16),
                    textColor: .black)
    }
}

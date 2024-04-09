//
//  NSLayoutConstraint+Extensions.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation

public extension NSLayoutConstraint {
    
    static func widthConstraint(to item: UIView, value: CGFloat, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let const = NSLayoutConstraint(item: item,
                                  attribute: .width,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: multiplier,
                                  constant: value)
        const.priority = priority
        return const
    }
    
    static func heightConstraint(to item: UIView, value: CGFloat, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let const = NSLayoutConstraint(item: item,
                                  attribute: .height,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  multiplier: multiplier,
                                  constant: value)
        const.priority = priority
        return const
    }
    
    static func aspectRatio(to item: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        
        return  NSLayoutConstraint(item: item,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: item,
                                   attribute: .width,
                                   multiplier: multiplier,
                                   constant: 0)
    }
    
    static func leftMargin(to item: UIView, value: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        
        return item.leadingAnchor.constraint(equalTo: item.leadingAnchor, constant: value)
    }
    
    static func rightMargin(to item: UIView, value: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        
        return item.trailingAnchor.constraint(equalTo: item.trailingAnchor, constant: -value)
    }
    
    static func topMargin(to item: UIView, value: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        
        return item.topAnchor.constraint(equalTo: item.topAnchor, constant: value)
    }
    
    static func bottomMargin(to item: UIView, value: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        
        return item.bottomAnchor.constraint(equalTo: item.bottomAnchor, constant: -value)
    }
    
    static func equalWidth(to item: UIView, secondItem: UIView, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let const = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: secondItem, attribute: .width, multiplier: multiplier, constant: 0.0)
        const.priority = priority
        return const
    }
    
    static func equalHeight(to item: UIView, secondItem: UIView, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let const = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: secondItem, attribute: .width, multiplier: multiplier, constant: 0.0)
        const.priority = priority
        return const
    }
    
    static func centerX(to item: UIView, secondItem: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        
        return NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: secondItem, attribute: .centerX, multiplier: multiplier, constant: 0)
    }
    
    static func centerY(to item: UIView, secondItem: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        
        return NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: secondItem, attribute: .centerY, multiplier: multiplier, constant: 0)
    }
}

//
//  UIStackView+Extensions.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation

public extension UIStackView {
    
    func getBannerView() -> UniNotificationBanner? {
        
        for vv in self.arrangedSubviews {
            if vv.isKind(of: UniNotificationBanner.self) {
                return vv as? UniNotificationBanner
            }
        }
        return nil
    }
    
    func addBannerView(_ chip: UniNotificationBanner, tableView: UniTableView?) {
        
        var contains = false
        for vv in self.arrangedSubviews {
            if vv.isKind(of: UniNotificationBanner.self) {
                contains = true
            }
        }
        if contains == true {
            return
        } else {
            self.insertArrangedSubview(chip, at: 0)
        }
    }
    
    func removeBannerView(tableView: UniTableView?) {
        
        for vv in self.arrangedSubviews {
            if vv.isKind(of: UniNotificationBanner.self) {
                self.removeArrangedSubview(vv)
                vv.removeFromSuperview()
                return
            }
        }
    }
    
    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func axis(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        
        self.axis = axis
        return self
    }
    
    func spacing(_ spacing: CGFloat) -> UIStackView {
        
        self.spacing = spacing
        return self
    }
}

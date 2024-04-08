//
//  UniLoadingView.swift
//  MPUIKit
//
//  Created by Marian Polek on 08/04/2024.
//


import Foundation
import UIKit


open class UniLoadingView: UIView, UniViewWithInsets {
    
    public var insets: UIEdgeInsets
    var loadingIndicator: UIActivityIndicatorView

    public init(style: UIActivityIndicatorView.Style = .medium,
                insets: UIEdgeInsets = .all20) {
        self.insets = insets
        self.loadingIndicator = UIActivityIndicatorView(style: style)

        super.init(frame: CGRect.basic)
        

        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
    
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loadingIndicator)
        NSLayoutConstraint.activate(
            [
                NSLayoutConstraint(item: loadingIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: loadingIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            ]
        )
    }
}

public extension UniLoadingView {
    
    func startActivityIndicator() {
        self.loadingIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.loadingIndicator.stopAnimating()
    }
}

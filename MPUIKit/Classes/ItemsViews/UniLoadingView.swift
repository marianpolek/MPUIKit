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
    
        self.embedCenterXY(loadingIndicator, insets: self.insets)
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

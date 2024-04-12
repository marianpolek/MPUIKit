//
// UniImageView
// MPUIKit
//
//  Created by Marian Polek on 02/03/2024.
//  
//  

import Foundation
import UIKit


open class UniImageView: UIView, UniViewWithInsets {
    
    public var insets: UIEdgeInsets
    var image: UIImage
    var size: CGFloat? = nil

    public init(image: UIImage, size: CGFloat? = nil, insets: UIEdgeInsets = .all20) {
        self.insets = insets
        self.image = image
        self.size = size
        super.init(frame: CGRect.basic)
        
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
    
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.image
        if let size = self.size {
//            imageView.setHeight(size)
            imageView.setWidth(size)
        }
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        NSLayoutConstraint.activate(
            [
                NSLayoutConstraint.topMarginGreaterOrEqual(to: imageView, secondItem: self, value: insets.top),
                NSLayoutConstraint.leftMarginGreaterOrEqual(to: imageView, secondItem: self, value: insets.top),
                NSLayoutConstraint.rightMarginGreaterOrEqual(to: self, secondItem: imageView, value: insets.top),
                NSLayoutConstraint.bottomMarginGreaterOrEqual(to: self, secondItem: imageView, value: insets.top),
                NSLayoutConstraint.centerX(to: imageView, secondItem: self),
                NSLayoutConstraint.centerY(to: imageView, secondItem: self)
            ]
        )
    }
}

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
                imageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: insets.top),
                imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: insets.left),
                self.trailingAnchor.constraint(greaterThanOrEqualTo: imageView.trailingAnchor, constant: -insets.right),
                self.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: -insets.bottom),
                NSLayoutConstraint.centerX(to: imageView, secondItem: self),
                NSLayoutConstraint.centerY(to: imageView, secondItem: self)
            ]
        )
    }
}

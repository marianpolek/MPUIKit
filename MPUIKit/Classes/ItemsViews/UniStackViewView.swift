//
// UniStackViewView
// MPUIKit
//
//  Created by Marian Polek on 06/03/2024.
//  
//  

import Foundation
import UIKit

open class UniStackViewView: UIView, UniViewWithInsets {
    
    public var insets: UIEdgeInsets
    
    var items: [UniViewWithInsets]
    var axis: NSLayoutConstraint.Axis
    var spacing: CGFloat
    var distribution: UIStackView.Distribution = .fill
    
    public init(items: [UniViewWithInsets],
         axis: NSLayoutConstraint.Axis,
         spacing: CGFloat,
         distribution: UIStackView.Distribution = .fill,
         _ insets: UIEdgeInsets = UIEdgeInsets.horizontal0Vertical20) {
        self.insets = insets
        self.items = items
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        super.init(frame: CGRect.basic)
        
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public func setup() {

        let stackView = UIStackView()
        stackView.axis = self.axis
        stackView.spacing = self.spacing
        stackView.distribution = self.distribution
        stackView.alignment = .fill
        
        for item in self.items {
            stackView.addArrangedSubview(item)
            item.setup()
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate(
            [
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ]
        )
    }
}

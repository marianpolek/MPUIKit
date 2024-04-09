//
// UniSeparatorView
// MPUIKit
//
//  Created by Marian Polek on 29/02/2024.
//  
//  

import Foundation
import UIKit

open class UniSeparatorView: UIView, UniViewWithInsets {
    
    public var insets: UIEdgeInsets

    public init(backgroundColor: UIColor = .gray,
                height: CGFloat = 1,
                insets: UIEdgeInsets = UIEdgeInsets.zero) {
        self.insets = insets
        super.init(frame: CGRect.basic)
        
        let view = UIView()
        
        view.backgroundColor = backgroundColor
        view.setHeight(height)
        
        self.embed(view, insets: self.insets)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

    public init(insets: UIEdgeInsets = UIEdgeInsets.zero) {
        self.insets = insets
        super.init(frame: CGRect.basic)
        
        let view = UIView()
        
        view.backgroundColor = .gray
        view.setHeight(1)
        
        self.embed(view, insets: self.insets)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
// UniTitleView
// MPUIKit
//
//  Created by Marian Polek on 29/02/2024.
//  
//

import Foundation
import UIKit

open class UniTitleView: UIView, UniViewWithInsets {
    
    var text: String
    var numberOfLines: Int
    var alignment: NSTextAlignment
    public var insets: UIEdgeInsets
    
    public init(text: String,
                numberOfLines: Int = 0,
                alignment: NSTextAlignment = .left,
                _ insets: UIEdgeInsets = UIEdgeInsets.all20) {
        self.text = text
        self.numberOfLines = numberOfLines
        self.alignment = alignment
        self.insets = insets
        super.init(frame: CGRect.basic)
        
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        
        let label = UILabel(frame: CGRect.basic)
        label.text = self.text
        label.numberOfLines = self.numberOfLines
        label.textAlignment = self.alignment
        
        self.embed(label, insets: self.insets)
        
    }
}

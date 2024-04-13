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
    private let viewSkin: UIView.Skin
    private let labelSkin: UILabel.Skin
    public var insets: UIEdgeInsets
    
    public init(text: String,
                numberOfLines: Int = 0,
                alignment: NSTextAlignment = .left,
                viewSkin: UIView.Skin = .clear(),
                labelSkin: UILabel.Skin = .black16(),
                _ insets: UIEdgeInsets = UIEdgeInsets.all20) {
        self.text = text
        self.numberOfLines = numberOfLines
        self.alignment = alignment
        self.viewSkin = viewSkin
        self.labelSkin = labelSkin
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
        
        self.apply(skin: self.viewSkin)
        label.apply(skin: self.labelSkin)
        
        self.embed(label, insets: self.insets)
    }
}

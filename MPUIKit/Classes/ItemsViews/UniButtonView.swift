//
// UniButtonView
// MPUIKit
//
//  Created by Marian Polek on 29/02/2024.
//  
//  

import Foundation
import UIKit

open class UniButtonView: UIView, UniViewWithInsets {
    
    public var insets: UIEdgeInsets
    
    var button: UniButton

    public init(button: UniButton,
                _ insets: UIEdgeInsets = UIEdgeInsets.all20) {

        self.insets = insets
        self.button = button
        
        super.init(frame: CGRect.basic)
        
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public func setup() {

        self.button.setTitleColor(.blue, for: .normal)
        
        self.embed(button, insets: self.insets)
    }
}


open class UniButton: UIButton {
    
    var action: (() -> ())?
    
    public func title(_ text: String) -> Self {
        
        self.setTitle(text, for: .normal)
        return self
    }
    
    public func isEnabled(_ state: Bool) -> Self {
        self.isEnabled = state
        return self
    }
    
    public func textAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = alignment
        return self
    }
    
    public func tapAction(action: @escaping () -> ()) -> Self {
        self.action = action
        self.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        return self
    }
    
    @objc
    func pressed() {
        action?()
    }
}

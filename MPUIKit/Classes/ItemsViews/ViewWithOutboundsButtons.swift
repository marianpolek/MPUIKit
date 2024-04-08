//
// ViewWithOutboundsButtons
// MPUIKit
//
//  Created by Marian Polek on 22/02/2024.
//  
//  

import Foundation
import UIKit

open class ViewWithOutboundsButtons: UIView {
    
    func hitTestOutbounds(_ point: CGPoint, with event: UIEvent?) -> UIView? {
     
        for view in self.subviews {
            if CGRectContainsPoint(view.frame, point) {
                if view.isKind(of: ViewWithOutboundsButtons.self) {
                    let convertPoint = self.convert(point, to: view)
                    return view.hitTest(convertPoint, with: event)
                } else if view.isKind(of: UIControl.self) {
                    return view
                }
            }
        }
        return nil
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let view = self.hitTestOutbounds(point, with: event) {
            return view
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

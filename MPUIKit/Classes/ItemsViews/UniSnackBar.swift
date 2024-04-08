//
//  UniSnackBar.swift
//  MPUIKit
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation

final public class UniSnackBar: UniNotificationBanner {

    public init(frame: CGRect,
                snackBarBottomSpace: CGFloat = 20) {
        
        super.init(frame: frame, showFromTop: false, automaticallyHide: true)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  UniSnackBar.swift
//  MPUIKit
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation

final public class UniSnackBar: UniNotificationBanner {

    public init(frame: CGRect,
                viewSkin: UIView.Skin = .whiteFlat(),
                titleSkin: UILabel.Skin = .black16(),
                snackBarBottomSpace: CGFloat = 20) {
        
        super.init(frame: frame,
                   viewSkin: viewSkin,
                   titleSkin: titleSkin,
                   config: UniAnimateShowAndHide.AniAnimateShowAndHideConfig(showFromTop: false,
                                                                             automaticallyHide: true,
                                                                             animate: true,
                                                                             canBeClosed: true))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

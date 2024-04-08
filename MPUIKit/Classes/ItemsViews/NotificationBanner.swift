//
//  NotificationBanner.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation
import UIKit

public struct NotificationBannerConfig {
    public let title: String
    public var icon: UIImage?
    public var customClose: Bool
    
    public init(title: String, icon: UIImage? = nil, customClose: Bool = false) {
        self.title = title
        self.icon = icon
        self.customClose = customClose
    }
}

open class NotificationBanner: UIView {
    
}

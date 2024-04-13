//
//  UniNotificationBanner.swift
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

open class UniNotificationBanner: UniAnimateShowAndHide, UniViewWithInsets {
    
    public var insets: UIEdgeInsets

    var rightImage: UIImageView
    var leftImage: UIImageView
    var label: UILabel
    var closeButton: UIButton
    
    public var text: String? {
        didSet {
            label.text = text
        }
    }
    
    public func leftImage(image: UIImage?, width: CGFloat? = nil, height: CGFloat? = nil) {
        leftImage.isHidden = image == nil
        leftImage.image = image
        if let width = width {
            leftImage.setWidth(width)
        }
        if let height = height {
            leftImage.setHeight(height)
        }
    }
        
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(frame: CGRect,
                viewSkin: UIView.Skin = .whiteFlat(),
                titleSkin: UILabel.Skin = .black16(),
                config: AniAnimateShowAndHideConfig,
                _ insets: UIEdgeInsets = UIEdgeInsets.all20) {
        
        self.insets = insets
        self.rightImage = UIImageView(frame: .basic).setWidth(24).setHeight(24)
        self.leftImage = UIImageView(frame: .basic).setWidth(24).setHeight(24)
        self.label = UILabel(frame: .basic)
        self.closeButton = UIButton().setWidth(40).setHeight(40)

        super.init(frame: frame)

        self.config = config
        
        
        let stackView = UIStackView(frame: .basic).axis(.horizontal).setHeight(28)
        stackView.spacing = 10
        
        self.label.numberOfLines = 0
        self.label.apply(skin: titleSkin)
        
        stackView.addArrangedSubview(leftImage)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(closeButton)

        
        self.closeButton.setImage(UIImage.init(systemName: "xmark"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(closeButtonTap(_:)), for: .touchUpInside)

        self.embed(stackView, insets: self.insets)
        
        self.apply(skin: viewSkin)
        
        initAppearance()
    }
    
    private func initAppearance() {

        rightImage.image = UIImage.init(systemName: "xmark")
        leftImage(image: UIImage.init(systemName: "info.circle"))
        
        self.config.canBeClosed ? setupPanGesture() : nil
        config.startingPosition = frame.origin
        
        if self.config.canBeClosed {
            self.rightImage.isHidden = false
            self.closeButton.isHidden = false
        } else {
            self.rightImage.isHidden = true
            self.closeButton.isHidden = true
        }
    }
}

open class UniAnimateShowAndHide: UIView {
    
    public struct AniAnimateShowAndHideConfig {
        
        public var showFromTop: Bool
        public var automaticallyHide: Bool
        public var animate: Bool
        public var canBeClosed: Bool
        
        public var startingPosition: CGPoint?
        public var snackBarBottomSpace: CGFloat = 20
        public var topBarTopSpace: CGFloat = 0
        
        public var didRemoveFromSuperview: (() -> Void)?
        public var customCloseAction: (() -> Void)?
        
        public init(showFromTop: Bool, automaticallyHide: Bool, animate: Bool, canBeClosed: Bool, startingPosition: CGPoint? = nil, snackBarBottomSpace: CGFloat = 20, topBarTopSpace: CGFloat = 0, didRemoveFromSuperview: ( () -> Void)? = nil, customCloseAction: ( () -> Void)? = nil) {
            self.showFromTop = showFromTop
            self.automaticallyHide = automaticallyHide
            self.animate = animate
            self.canBeClosed = canBeClosed
            self.startingPosition = startingPosition
            self.snackBarBottomSpace = snackBarBottomSpace
            self.topBarTopSpace = topBarTopSpace
            self.didRemoveFromSuperview = didRemoveFromSuperview
            self.customCloseAction = customCloseAction
        }
    }
    
    public var config: AniAnimateShowAndHideConfig
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        
        self.config = AniAnimateShowAndHideConfig(showFromTop: false, automaticallyHide: false, animate: true, canBeClosed: true)
        
        super.init(frame: frame)
    }

    public convenience init(config: AniAnimateShowAndHideConfig) {
        self.init(frame: .basic)

        self.config = config
    }
    
    public override func didMoveToSuperview() {
        showNotificationBanner()
    }
    
    public func showNotificationBanner() {

        UIView.animate(withDuration: self.config.animate ? 0.4 : 0) { [weak self] in
            guard let self = self, let superView = self.superview else { return }

            self.frame.origin.y = self.config.showFromTop ? self.config.topBarTopSpace : (superView.frame.height - self.frame.height - self.config.snackBarBottomSpace)
        } completion: { [weak self] (_) in
            guard let self = self else { return }
            if self.config.automaticallyHide {
                let hideTask = DispatchWorkItem { [weak self] in
                    self?.hideNotificationBanner(to: .down)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: hideTask)
            }
        }
    }
    
    func hideTopBar(to direction: UISwipeGestureRecognizer.Direction) {
        hideNotificationBanner(to: direction)
    }
    
    func hideSnackBar(to direction: UISwipeGestureRecognizer.Direction) {
        hideNotificationBanner(to: direction)
    }
    
    func hideNotificationBanner(to direction: UISwipeGestureRecognizer.Direction) {
        UIView.animate(withDuration: self.config.animate ? 0.4 : 0) { [weak self] in
            guard let self = self, let superView = self.superview else { return }

            switch direction {
            case .up:
                self.frame.origin.y = (self.config.startingPosition?.y ?? 0) - self.frame.height
            case .down:
                self.frame.origin.y = self.config.startingPosition?.y ?? 0
            case .left:
                self.frame.origin.x = 0 - self.frame.width
            case .right:
                self.frame.origin.x = superView.frame.width
            default:
                return
            }
        } completion: { [weak self] (_) in
            self?.removeFromSuperview()
            self?.config.didRemoveFromSuperview?()
        }
    }

    @IBAction func closeButtonTap(_ sender: UIButton) {
        if let customAction = config.customCloseAction {
            customAction()
        } else {
            hideNotificationBanner(to: self.config.showFromTop ? .up : .down)
        }
    }
    
    func setupPanGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        rightSwipe.direction = .right
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        leftSwipe.direction = .left

        

        self.addGestureRecognizer(rightSwipe)
        self.addGestureRecognizer(leftSwipe)
        
        if self.config.showFromTop {
            
            let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            upSwipe.direction = .up
            self.addGestureRecognizer(upSwipe)

        } else {
            
            let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            downSwipe.direction = .down
            self.addGestureRecognizer(downSwipe)

        }
    }
    
    @objc
    private func handleGesture(_ sender: UISwipeGestureRecognizer) {
        hideNotificationBanner(to: sender.direction)
    }
    
}

public extension UniAnimateShowAndHide.AniAnimateShowAndHideConfig {
    
    static var notMoveableOrAnimateable: UniAnimateShowAndHide.AniAnimateShowAndHideConfig {
        return UniAnimateShowAndHide.AniAnimateShowAndHideConfig(showFromTop: false, automaticallyHide: false, animate: false, canBeClosed: false)
    }
    
    static var snackBarType: UniAnimateShowAndHide.AniAnimateShowAndHideConfig {
        return UniAnimateShowAndHide.AniAnimateShowAndHideConfig(showFromTop: false, automaticallyHide: true, animate: true, canBeClosed: true, startingPosition: CGPoint(x: 0, y: UIScreen.main.bounds.height))
    }
    
    static var bannerType: UniAnimateShowAndHide.AniAnimateShowAndHideConfig {
        return UniAnimateShowAndHide.AniAnimateShowAndHideConfig(showFromTop: true, automaticallyHide: false, animate: false, canBeClosed: true)
    }
}

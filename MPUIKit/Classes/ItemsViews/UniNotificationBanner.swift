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

open class UniNotificationBanner: UIView, UniViewWithInsets {
    
    public var insets: UIEdgeInsets

    var rightImage: UIImageView
    var leftImage: UIImageView
    var label: UILabel
    var closeButton: UIButton
    
    private var startingPosition: CGPoint?
    private var snackBarBottomSpace: CGFloat = 20
    private var topBarTopSpace: CGFloat = 0
    public var didRemoveFromSuperview: (() -> Void)?
    public var customCloseAction: (() -> Void)?

    private var showFromTop: Bool
    private var automaticallyHide: Bool
    private var animate: Bool
    private var canBeClosed: Bool
    
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
                snackBarBottomSpace: CGFloat = 20,
                topBarTopSpace: CGFloat = 0,
                showFromTop: Bool,
                automaticallyHide: Bool = false,
                animate: Bool = true,
                canBeClosed: Bool = true,
                _ insets: UIEdgeInsets = UIEdgeInsets.all20) {
        
        self.snackBarBottomSpace = snackBarBottomSpace
        self.topBarTopSpace = topBarTopSpace
        self.showFromTop = showFromTop
        self.automaticallyHide = automaticallyHide
        self.animate = animate
        self.canBeClosed = canBeClosed
        self.insets = insets
        
        
        let stackView = UIStackView(frame: .basic).axis(.horizontal).setHeight(28)
        stackView.spacing = 10
        
        self.leftImage = UIImageView(frame: .basic).setWidth(30).setHeight(30)
        self.label = UILabel(frame: .basic)
        self.label.numberOfLines = 2
        self.rightImage = UIImageView(frame: .basic).setWidth(30).setHeight(30)
        self.closeButton = UIButton()
        
        stackView.addArrangedSubview(leftImage)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(rightImage)

        super.init(frame: frame)
        
        self.closeButton.addTarget(self, action: #selector(closeButtonTap(_:)), for: .touchUpInside)

        self.embed(stackView, insets: self.insets)
        initAppearance()
    }
    
    private func initAppearance() {

        rightImage.image = UIImage.init(systemName: "xmark")
        leftImage(image: UIImage.init(systemName: "info.circle"))
        
        self.canBeClosed ? setupPanGesture() : nil
        startingPosition = frame.origin
        
        if self.canBeClosed {
            self.rightImage.isHidden = false
            self.closeButton.isHidden = false
        } else {
            self.rightImage.isHidden = true
            self.closeButton.isHidden = true
        }
    }
    
    public override func didMoveToSuperview() {
        showNotificationBanner()
    }
    
    private func showNotificationBanner() {

        UIView.animate(withDuration: self.animate ? 0.4 : 0) { [weak self] in
            guard let self = self, let superView = self.superview else { return }

            self.frame.origin.y = self.showFromTop ? self.topBarTopSpace : (superView.frame.height - self.frame.height - self.snackBarBottomSpace)
        } completion: { [weak self] (_) in
            guard let self = self else { return }
            if self.automaticallyHide {
                let hideTask = DispatchWorkItem { [weak self] in
                    self?.hideNotificationBanner(to: .down)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: hideTask)
            }
        }
    }
    
    public func hideTopBar(to direction: UISwipeGestureRecognizer.Direction) {
        hideNotificationBanner(to: direction)
    }
    
    public func hideSnackBar(to direction: UISwipeGestureRecognizer.Direction) {
        hideNotificationBanner(to: direction)
    }
    
    public func hideNotificationBanner(to direction: UISwipeGestureRecognizer.Direction) {
        UIView.animate(withDuration: self.animate ? 0.4 : 0) { [weak self] in
            guard let self = self, let superView = self.superview else { return }

            switch direction {
            case .up:
                self.frame.origin.y = (self.startingPosition?.y ?? 0) - self.frame.height
            case .down:
                self.frame.origin.y = self.startingPosition?.y ?? 0
            case .left:
                self.frame.origin.x = 0 - self.frame.width
            case .right:
                self.frame.origin.x = superView.frame.width
            default:
                return
            }
        } completion: { [weak self] (_) in
            self?.removeFromSuperview()
            self?.didRemoveFromSuperview?()
        }
    }

    @IBAction func closeButtonTap(_ sender: UIButton) {
        if let customAction = customCloseAction {
            customAction()
        } else {
            hideNotificationBanner(to: self.showFromTop ? .up : .down)
        }
    }
    
    func setupPanGesture() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        rightSwipe.direction = .right
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        leftSwipe.direction = .left

        

        self.addGestureRecognizer(rightSwipe)
        self.addGestureRecognizer(leftSwipe)
        
        if self.showFromTop {
            
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


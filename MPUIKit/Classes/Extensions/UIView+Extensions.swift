//
//  UIView+Extensions.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation


public extension UIView {
    
    func hideAlertInfoView() {
        
    }
    
    func showAlertInfoView(view: UIView) {
        
    }
    
    /// add width constraint for view
    /// - Parameter value: width value
    @discardableResult func setWidth(_ value: CGFloat) -> Self {
        self.addConstraint(NSLayoutConstraint.widthConstraint(to: self, value: value))
        return self
    }
    
    /// add height constraint for view
    /// - Parameter value: height value
    @discardableResult func setHeight(_ value: CGFloat) -> Self {
        self.addConstraint(NSLayoutConstraint.heightConstraint(to: self, value: value))
        return self
    }
    
    
    static func shimmeringLoadingView() -> UIView {
        
        let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
//        containerView.backgroundColor = .cN90
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isScrollEnabled = false
        containerView.embed(scrollView)
        
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.isLayoutMarginsRelativeArrangement = true
        scrollView.embed(stackView)
        
        stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0).isActive = true
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 20).isActive = true
        
        for _ in 1...5 {
            let shimmerTitle = ShimmerTitleLoadingView()
//            shimmerTitle.skin = .default()
            stackView.addArrangedSubview(shimmerTitle)
            shimmerTitle.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            
            DispatchQueue.main.async {
                shimmerTitle.startShimmerAnimation()
            }
        }
        
        return containerView
    }
    
    func startShimmeringAnimation(animationSpeed: Float = 1.0) {
        
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        let blackColor = UIColor.black.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
            
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientLayer.locations =  [0.35, 0.50, 0.65]
        self.layer.mask = gradientLayer
        
        CATransaction.begin()
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = .infinity
        
        CATransaction.setCompletionBlock { [weak self] in
            self?.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        
        CATransaction.commit()
    }
    
    func stopShimmeringAnimation() {
        self.layer.mask = nil
    }
    
    
    func removeSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    @objc func embed(_ view: UIView, insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
            ]
        )
    }
    
    @objc func embedToSafeGuide(_ view: UIView, insets: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let guide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: guide.topAnchor, constant: insets.top),
                view.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: insets.left),
                view.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -insets.right),
                view.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -insets.bottom)
            ]
        )
    }
}

//
// JustTableViewCoordinator
// MPUIKit
//
//  Created by Marian Polek on 21/02/2024.
//  
//  

import Foundation
import UIKit
import MPUIKit

public protocol ExampleUniTableViewCoordinatorType {

    func dismiss()
}

public class ExampleUniViewControllerCoordinator: ExampleUniTableViewCoordinatorType {
    
    
    private weak var rootViewController: UIViewController?
    weak var currentController: UIViewController?
    
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    public func start(_ footerType: UniViewController.FooterStickyType) {
        let jtvVC = UniViewController()
        jtvVC.viewModel = ExampleUniViewModel(coordinator: self,
                                                 footerType: footerType)
        currentController = jtvVC
        jtvVC.modalPresentationStyle = .fullScreen
        rootViewController?.show(jtvVC, sender: nil)
    }
    
    public func dismiss() {
        
    }
}

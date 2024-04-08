//
//  TypesListCoordinator.swift
//  MPUIKit_example
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation
import UIKit
import MPUIKit

public protocol TypesListCoordinatorType {

    func showNextScreen(_ type: UniViewController.FooterStickyType)
    func showPaginationExample()
}

public class TypesListCoordinator: TypesListCoordinatorType {
    
    
    private var window: UIWindow
    weak var currentController: UIViewController?
    
    public init(window: UIWindow) {
        self.window = window
    }
    
    public func start() {
        
        let typesVC = UniViewController()
        typesVC.viewModel = TypesListViewModel(coordinator: self,
                                              footerType: .classicTableFooter)
        currentController = typesVC
        
        let navC = UINavigationController(rootViewController: typesVC)

        window.rootViewController = navC
        window.makeKeyAndVisible()
    }
    
    public func showNextScreen(_ type: UniViewController.FooterStickyType) {
        
        guard let cc = currentController else { return }
        
        if type == .classicTableFooter || type == .fixedDownTheScreen {
            
            ExampleUniViewControllerCoordinator(rootViewController: cc).start(type)
        } else {
            
            Example2UniViewControllerCoordinator(rootViewController: cc).start(type)
        }
    }
    
    public func showPaginationExample() {
        
        guard let cc = currentController else { return }
        PaginationUniViewControllerCoordinator(rootViewController: cc).start(.classicTableFooter)

    }
}

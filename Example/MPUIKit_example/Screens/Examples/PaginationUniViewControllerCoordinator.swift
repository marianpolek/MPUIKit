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

public protocol PaginationUniTableViewCoordinatorType {

    func dismiss()
    func startLoading()
    func stopLoading()
}

public class PaginationUniViewControllerCoordinator: PaginationUniTableViewCoordinatorType {
    
    
    private weak var rootViewController: UIViewController?
    weak var currentController: UIViewController?
    
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    public func start(_ footerType: UniViewController.FooterStickyType) {
        let jtvVC = UniViewController()
        jtvVC.viewModel = PaginationUniViewModel(coordinator: self,
                                                 footerType: footerType,
                                                 paginationManager: PaginationManager<ResponseItem, AppError>(isConnectedToInternet: { return true }),
                                                 networkingService: NetworkingService())
        currentController = jtvVC
        jtvVC.modalPresentationStyle = .fullScreen
        rootViewController?.show(jtvVC, sender: nil)
    }
    
    public func dismiss() {
        
    }
    
    public func startLoading() {
        self.currentController?.view.showLoader()
    }
    
    public func stopLoading() {
        self.currentController?.view.hideLoader()
    }
}

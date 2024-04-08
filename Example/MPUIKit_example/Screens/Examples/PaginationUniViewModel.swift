//
// UniTableViewViewModel
// MPUIKit
//
//  Created by Marian Polek on 21/02/2024.
//  
//

import Foundation
import UIKit
import MPUIKit

class PaginationUniViewModel: UniViewModelBase {
    
    private let coordinator: PaginationUniTableViewCoordinatorType
    private var tableView: UniTableView?
    private var footerType: UniViewController.FooterStickyType
    private var paginationManager: PaginationManager<ResponseItem, AppError>
    private var networkingService: NetworkingService
    
    init(coordinator: PaginationUniTableViewCoordinatorType,
         footerType: UniViewController.FooterStickyType,
         paginationManager: PaginationManager<ResponseItem, AppError>,
         networkingService: NetworkingService) {
        self.coordinator = coordinator
        self.footerType = footerType
        self.paginationManager = paginationManager
        self.networkingService = networkingService
        
        super.init()
        
        bindInputs()
        
        paginationManager.fetchItems = { [weak self] page, pageSize, completionBlock in

            guard let self = self else { return }
                        
            self.networkingService.getResponsItems(
                page: page,
                pageSize: pageSize) { result in
                    completionBlock(result)
                }
        }
        
        paginationManager.statusChanged = { [weak self] status in
            
            guard let self = self else { return }
            
            switch status {
            case .startedLoading:
                self.coordinator.startLoading()
                
            case .finishedLoading:
                self.coordinator.stopLoading()

            case .items(let contexts, let totalCount):
                self.output.didEndRefreshing?()

                if contexts.count <= 0 {
                    self.output.showViewFullScreen?(UIView())
                } else {
                    self.handleTableItems(contexts as! [ResponseItem])
                }
                
            case .error(let page, let error):
                
                self.output.didEndRefreshing?()
//                self.showErrorDialog()
                
            case .noInternet(let page):
                
                self.output.didEndRefreshing?()
                self.output.bannerConfig?(NotificationBannerConfig(title: "error"))
            }
        }
    }
    
    override func bindInputs() {
        input.viewDidLoad = { [weak self] tableView in
            self?.tableView = tableView
            self?.viewDidLoad()
            
            self?.paginationManager.getFirstPage()
        }
        input.dismiss = { [weak self] in
            self?.coordinator.dismiss()
        }
    }
    
    private func viewDidLoad() {
        
        self.output.navTitle?("Pagination example")
        self.output.viewDidLoad?(self.footerType)
        self.output.refreshControlForTableView?()
        
        self.handleTableItems([])
        
    }
    
    private func filteringDidChangedAction() {
        
        self.paginationManager.pullToRefresh()
    }
    
    override func pullToRefresh() {
        self.paginationManager.pullToRefresh()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, _ tableView: UITableView) {
        self.paginationManager.scrollViewDidEndDecelerating(scrollView, tableView)
    }
}



extension PaginationUniViewModel {
    
    private func handleTableItems(_ contexts: [ResponseItem]) {
     

        var content: [UniViewWithInsets] = []
        for x in 0..<contexts.count {
            
            let cont = contexts[x]
            
            content.append(
                UniTitleView(text: cont.title)
            )
            if x < contexts.count-1 {
                content.append(UniSeparatorView(insets: .horizontal20Vertical0))
            }
            
        }
        
        tableItems.removeAll()
        tableItems = [(nil,
                       content
                      )]
        
        self.output.reloadTableData?(self.footerType)
    }
}

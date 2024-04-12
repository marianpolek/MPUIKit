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

class Example2UniViewModel: UniViewModelBase {
    
    private let coordinator: Example2UniTableViewCoordinatorType
    private var tableView: UniTableView?
    private var footerType: UniViewController.FooterStickyType
    
    private var tableListItems: [UniViewWithInsets] = []
    
    init(coordinator: Example2UniTableViewCoordinatorType,
         footerType: UniViewController.FooterStickyType) {
        self.coordinator = coordinator
        self.footerType = footerType
        
        super.init()
        
        bindInputs()
    }
    
    override func bindInputs() {
        input.viewDidLoad = { [weak self] tableView in
            self?.tableView = tableView
            self?.viewDidLoad()
        }
        input.dismiss = { [weak self] in
            self?.coordinator.dismiss()
        }
    }
    
    private func viewDidLoad() {
        
        self.output.viewDidLoad?(self.footerType)
        
        self.tableListItems = [UniSeparatorView(),
                               UniButtonView(button: UniButton().title(String.random(length: 10))
                                  .isEnabled(true)
                                  .tapAction { [weak self] in
                                                 
                                                 self?.output.showViewInList?(UIView.shimmeringLoadingView())
                                                 
                                                 DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
                                                     self?.output.hideViewInList?()
                                                 })
                                                 
                                                 self?.output.showSnackBar?(String.random(length: 40))

                                                 let bannerConfig = NotificationBannerConfig(
                                                     title: String.random(length: 40),
                                                     icon: UIImage.init(named: "Info-filled")
                                                 )
                                                 self?.output.bannerConfig?(bannerConfig)
                                             }),
                               UniButtonView(button: UniButton().title("add new item to list for testing purposes")
                                  .isEnabled(true)
                                  .tapAction { [weak self] in
                                      self?.addNewItemsToTableList()
                                             }),
                               UniNotificationBanner(frame: .basic, viewSkin: .redFlat(), config: UniAnimateShowAndHide.AniAnimateShowAndHideConfig(showFromTop: false, automaticallyHide: false, animate: false, canBeClosed: false))
                          ]
        
        
        self.output.topStickedItems?([UniTitleView(text: String.random(length: 40))
                                     ])
        
        tableItems.removeAll()
        tableItems = [
           (nil,
            self.tableListItems
            )
            ]
        
        
        self.output.reloadTableData?(self.footerType)
        
        
        self
            .output
            .setFooterViews?((self.footerType,
                              self
                    .stackView(items: [
                        UniTitleView(text: String.random(length: 140)),
                        UniSeparatorView(),
                        UniButtonView(button: UniButton().title(String.random(length: 10))
                            .isEnabled(true)
                            .tapAction { [weak self] in
                                           
                                           let bannerConfig = NotificationBannerConfig(
                                               title: String.random(length: 10),
                                               icon: UIImage.init(named: "Info-filled")
                                           )
                                           self?.output.bannerConfig?(bannerConfig)
                                       })
                    ])
                    .axis(.vertical)))
    }
    
    private func addNewItemsToTableList() {
        
        self.tableListItems.append(UniTitleView(text: String.random(length: 100)))
        
        tableItems = [
           (nil,
            self.tableListItems
            )
            ]
        
        self.output.reloadTableData?(self.footerType)
    }
}

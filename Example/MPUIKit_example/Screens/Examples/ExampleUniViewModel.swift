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

class ExampleUniViewModel: UniViewModelBase {
    
    private let coordinator: ExampleUniTableViewCoordinatorType
    private var tableView: UniTableView?
    private var footerType: UniViewController.FooterStickyType
    
    
    init(coordinator: ExampleUniTableViewCoordinatorType,
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
        
        
        self.output.topStickedItems?([UniTitleView(text: "top sticked items. in this example it's title view")
                                     ])
        
        tableItems.removeAll()
        tableItems = [
            (UniTitleView(text: "SECTION HEADER 1"),
            [UniTitleView(text: String.random(length: 40)),
             UniTitleView(text: String.random(length: 20)),
             UniTitleView(text: String.random(length: 30)),
             UniTitleView(text: String.random(length: 240)),
             UniTitleView(text: String.random(length: 140)),
             UniTitleView(text: String.random(length: 40)),
             UniTitleView(text: String.random(length: 50)),
             UniTitleView(text: String.random(length: 60)),
             UniTitleView(text: String.random(length: 70)),
             UniSeparatorView(),
             UniImageView(image: UIImage.init(systemName: "trash")!, size: 35),

            UniTitleView(text: String.random(length: 40)),
            UniTitleView(text: String.random(length: 40)),
            UniTextFieldView(title: String.random(length: 10),
                             didEndBlock: { string in
                                  return string?.count ?? 0 > 2 ? "error!" : nil
                              }),

            ]),

            
           (nil,
            [UniSeparatorView(),

             UniButtonView(button: UniButton().title(String.random(length: 10))
                .isEnabled(true)
                .tapAction { [weak self] in
                               
                               self?.output.showViewInList?(UIView.shimmeringLoadingView())
                               
                               DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
                                   self?.output.hideViewInList?()
                               })
                               
                               self?.output.showSnackBar?(String.random(length: 40))

                               let bannerConfig = NotificationBannerConfig(
                                   title: String.random(length: 30),
                                   icon: UIImage.init(systemName: "info.circle.fill")
                               )
                               self?.output.bannerConfig?(bannerConfig)
                           }),

             UniButtonView(button: UniButton().title(String.random(length: 10))
                .isEnabled(true)
                .tapAction { [weak self] in
                               self?.output.bannerConfig?(nil)
                           })
        ])
            ]
        
        
        self.output.reloadTableData?(self.footerType)
        
        
        self
            .output
            .setFooterViews?((self.footerType,
                              self
                    .stackView(items: [

                        UniTitleView(text: String.random(length: 40)),
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
}

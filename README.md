# MPUIKit
uikit helper ui 

Base idea:
-
Base skeleton of MVVM+C helper for quick creating simple screens. 
Views defined in view model, also with behaviour and functionality. 
Doesnt need to create storyboard or viewcontroller at all. 

Features:
-
4 types of screens: 
- classic tableView controller (tableView)
- tableView controller with fixed footer at the bottom (tableView)
- sticky bottom footer with top body content (stackView body)
- sticky bottom footer with middle body content (stackView body)

--
- for all types there is possible to set fixed top content
- preparation for pagination for tablesViews
- preparation for top banners
- preparation for bottom snackbars
- preparation for skins
- etc..

How to use it:
-

First step is to create Uni view controller and viewModel and set viewModel to view controller. ViewModel has to have footerType.  
```swift
let myVC = UniViewController()
myVC.viewModel = ExampleUniViewModel(footerType: .classicTableFooter)
// present / show / push / whatever view controller
```

then ViewModel
```swift
import Foundation
import UIKit
import MPUIKit

// viewModel has to inherite from UniViewModelBase
class ExampleUniViewModel: UniViewModelBase {
    
    private var tableView: UniTableView?
    private var footerType: UniViewController.FooterStickyType
    
    
    init(footerType: UniViewController.FooterStickyType) {
        self.footerType = footerType
        
        super.init()
        
        bindInputs()
        
    }
    
    override func bindInputs() {
        input.viewDidLoad = { [weak self] tableView in
            self?.tableView = tableView
            self?.viewDidLoad()
        }
    }
    
    private func viewDidLoad() {
        
        self.output.viewDidLoad?(self.footerType)

        // setup navigation title on the screen
        self.output.navTitle?("title")
        
        // you can setup top sticked views if needed 
        self.output.topStickedItems?([UniTitleView(text: "top sticked items. in this example it's title view")
                                     ])
        // setup main content. tableItems has header view and rows. So it's  [(UniViewWithInsets?, [UniViewWithInsets])]
        tableItems.removeAll()
        tableItems = [
            (UniTitleView(text: "SECTION HEADER 1"),
            [UniTitleView(text: String.random(length: 40)),
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
                               // you can show view in main content (tableView or stackView)
                               self?.output.showViewInList?(UIView.shimmeringLoadingView())
                               
                               DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
                                   self?.output.hideViewInList?()
                               })

                                // you can show snackBar via output
                               self?.output.showSnackBar?(String.random(length: 40))

                               let bannerConfig = NotificationBannerConfig(
                                   title: String.random(length: 30),
                                   icon: UIImage.init(systemName: "info.circle.fill")
                               )
                                // you can show banner with it's config
                               self?.output.bannerConfig?(bannerConfig)
                           }),

             UniButtonView(button: UniButton().title(String.random(length: 10))
                .isEnabled(true)
                .tapAction { [weak self] in
                                // hide banner
                               self?.output.bannerConfig?(nil)
                           })
        ])
            ]
        
        // refresh or relaod or show main content
        self.output.reloadTableData?(self.footerType)
        
        // this is special output for footer views. 
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

        // you can set navigation buttons as you want. it's a array of navigation items. 
        self.output.setNavButtons?([UINavigationItem.NavButtonModel(type: .close(.dark), position: .right),
                                   UINavigationItem.NavButtonModel(type: .backButton(.gray), position: .right)])
    }
}

```

You can check UniViewModelBase Output struct and see what everything is possible and what you can use. 

There is possibility to create any kind of view and use it in viewModel. It's just on your imagination. 

//
//  TypesListViewModel.swift
//  MPUIKit_example
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation
import UIKit
import MPUIKit

class TypesListViewModel: UniViewModelBase {
    
    private let coordinator: TypesListCoordinatorType
    private var tableView: UniTableView?
    private var footerType: UniViewController.FooterStickyType
    
    init(coordinator: TypesListCoordinatorType,
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
    }
    
    private func viewDidLoad() {
        
        self.output.viewDidLoad?(self.footerType)
        
        tableItems.removeAll()
        tableItems = [
            (UniTitleView(text: "SCREEN TYPES"),
             [UniButtonView(button: UniButton()
                                    .title("classic table footer")
                                    .isEnabled(true)
                                    .tapAction { [weak self] in
                                        self?.coordinator.showNextScreen(.classicTableFooter)
                                    }, .horizontal20Vertical10),
              UniButtonView(button: UniButton()
                                    .title("fixed down the screen")
                                    .isEnabled(true)
                                    .tapAction { [weak self] in
                                        self?.coordinator.showNextScreen(.fixedDownTheScreen)
                                    }, .horizontal20Vertical10),
              UniButtonView(button: UniButton()
                                    .title("sticky down - body top")
                                    .isEnabled(true)
                                    .tapAction { [weak self] in
                                        self?.coordinator.showNextScreen(.stickyDownBodyTop)
                                    }, .horizontal20Vertical10),
              UniButtonView(button: UniButton()
                                    .title("sticky down - body middle")
                                    .isEnabled(true)
                                    .tapAction { [weak self] in
                                        self?.coordinator.showNextScreen(.stickyDownBodyMiddle)
                                    }, .horizontal20Vertical10)
             ]),
            (UniTitleView(text: "OTHER TYPES"),
            [
                UniButtonView(button: UniButton()
                                      .title("Pagination example (classic table)")
                                      .isEnabled(true)
                                      .tapAction { [weak self] in
                                          self?.coordinator.showPaginationExample()
                                      }, .horizontal20Vertical10),
            ])
        ]
        
        self.output.reloadTableData?(self.footerType)
    }
}

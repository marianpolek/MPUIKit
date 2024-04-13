//
//  UniTableViewViewModelBase.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation
import UIKit

open class UniViewModelBase: BaseViewModel, ViewModelType, PaginationViewModelType {
    
    open func pullToRefresh() {}
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, _ tableView: UITableView) {}
    
    public var input = Input()
    public var output = Output()
    
    public var tableItems: [(UniViewWithInsets?, [UniViewWithInsets])] = []
    
    public struct Input {
        public var viewDidLoad: Callback<UniTableView?>?
        public var dismiss: CallbackVoid?
        public var takenFromFile: Callback<URL>?
    }
    
    public struct Output {
        public var viewDidLoad: Callback<UniViewController.FooterStickyType>?
        public var bannerConfig: Callback<NotificationBannerConfig?>?
        public var topStickedItems: Callback<[UniViewWithInsets]>?
        public var reloadTableData: Callback<UniViewController.FooterStickyType>?
        public var setFooterViews: Callback<(footerType: UniViewController.FooterStickyType, footerView: UIView)>?
        public var showSnackBar: Callback<String>?
        public var showViewFullScreen: Callback<UIView>?
        public var hideViewFullScreen: CallbackVoid?
        public var showViewInList: Callback<UIView>?
        public var hideViewInList: CallbackVoid?
        public var tableViewScrollEnabled: Callback<Bool>?
        public var navTitle: Callback<String>?
        public var setNavButtons: Callback<[UINavigationItem.NavButtonModel]>?
        public var refreshControlForTableView: CallbackVoid?
        public var showFileGetter: Callback<UIDocumentPickerViewController>?
        public var didEndRefreshing: CallbackVoid?
    }
    
    open func bindInputs() {}
}

public extension UniViewModelBase {
    
    func stackView(items: [UniViewWithInsets]) -> UIStackView {
        
        let sv = UIStackView()
        
        for item in items {
            sv.addArrangedSubview(item)
        }
        
        return sv
    }
}

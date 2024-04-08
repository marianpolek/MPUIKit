//
// JustTableViewController
// MPUIKit
//
//  Created by Marian Polek on 21/02/2024.
//  
//  

import Foundation
import UIKit

open class UniTableView: UITableView {
    

    
    var isKeyboardShown: Bool = false
}

open class UniStackView: UIStackView {
    
    var embedView: UIView?
    
    func showView(_ view: UIView) {
        self.embedView = view
        self.embed(view)
    }
    
    func hideView() {
        self.embedView?.removeFromSuperview()
    }
}

open class UniViewController: UIViewController {
    
    public enum FooterStickyType {
        
        case classicTableFooter
        case fixedDownTheScreen
        case stickyDownBodyTop
        case stickyDownBodyMiddle
    }
    
    var statusBarAppearanceDark: Bool? = nil
    var interactivePopGesture: Bool? = true
    var allowTableSelection: Bool? = nil
    
    var scrollView: UIScrollView = UIScrollView()
    var wholeScreenStackView: UIStackView = UIStackView()
    
    var tableView: UniTableView?
    var containerStackView: UniStackView?
    
    var footerView: UIView = UIView()
    var bottomConstraint: NSLayoutConstraint?
    public var viewModel: UniViewModelBase?

    var footerType: UniViewController.FooterStickyType? = .classicTableFooter

    lazy var refreshControl = UIRefreshControl()
    
    public init(statusBarAppearanceDark: Bool? = nil,
             interactivePopGesture: Bool? = true,
             allowTableSelection: Bool? = nil) {
        self.statusBarAppearanceDark = statusBarAppearanceDark
        self.interactivePopGesture = interactivePopGesture
        self.allowTableSelection = allowTableSelection
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        observersSetup()
        
        self.view.backgroundColor = .white
        
        bindInputs()
        
        viewModel?.input.viewDidLoad?(self.tableView)
        
        if self.interactivePopGesture == false {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }

    }
    
//    func updateStatusBarColor() {
//        super.updateStatusBarColor()
//        if let sba = self.statusBarAppearanceDark {
//            setStatusBarAppearance(isDark: sba)
//        }
//    }
    
//    open override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateStatusBarColor()
//    }
    
    fileprivate func observersSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func bindInputs() {
        
        viewModel?.output.navTitle = { [weak self] title in
            self?.title = title
        }
        
        viewModel?.output.viewDidLoad = { [weak self] footerType in
        
            guard let self = self else { return }
            
            for vv in self.view.subviews {
                if vv == self.wholeScreenStackView {
                    vv.removeFromSuperview()
                    self.wholeScreenStackView = UIStackView()
                    break
                }
            }
            
            _ = self.wholeScreenStackView.axis(.vertical)
            self.wholeScreenStackView.translatesAutoresizingMaskIntoConstraints = false

            self.view.addSubview(self.wholeScreenStackView)
            let guide = self.view.safeAreaLayoutGuide

            self.bottomConstraint = guide.bottomAnchor.constraint(equalTo: self.wholeScreenStackView.bottomAnchor, constant: 0)
            NSLayoutConstraint.activate(
                [
                    self.wholeScreenStackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
                    self.wholeScreenStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
                    self.wholeScreenStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
                ]
            )
            if let bc = self.bottomConstraint {
                NSLayoutConstraint.activate([bc])
            }

            if footerType == .classicTableFooter ||
                footerType == .fixedDownTheScreen {
                
                tableView = UniTableView()
                guard let tableView = tableView else { return }
                
                tableView.separatorStyle = .none
                if let ats = self.allowTableSelection {
                    tableView.allowsSelection = ats
                }
        //        tableView.contentInsetAdjustmentBehavior = .never;
                
                tableView.register(UniTableViewCell.self, forCellReuseIdentifier: UniTableViewCell.reuseIdentifier)
                
                tableView.delegate = self
                tableView.dataSource = self
                
                self.wholeScreenStackView.addArrangedSubview(tableView)
                
                if footerType == .fixedDownTheScreen {
                    self.wholeScreenStackView.addArrangedSubview(self.footerView)
                }
                
            } else if footerType == .stickyDownBodyTop ||
                        footerType == .stickyDownBodyMiddle{
                
                self.scrollView.removeFromSuperview()
                self.scrollView = UIScrollView()
                self.wholeScreenStackView.addArrangedSubview(self.scrollView)

                
                let containerView = UIView()
                self.scrollView.embed(containerView)
                
                
                let upperView = UIView()
                
                upperView.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(upperView)
                NSLayoutConstraint.activate(
                    [
                        upperView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
                        upperView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
                        upperView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
                    ]
                )
                
                self.containerStackView = UniStackView()
                guard let containerStackView = self.containerStackView else { return }
                
                _ = containerStackView.axis(.vertical).spacing(0)
                containerStackView.distribution = .fill
                
                if footerType == .stickyDownBodyTop {
                    upperView.embed(containerStackView)
                } else if footerType == .stickyDownBodyMiddle {
                    
                    containerStackView.translatesAutoresizingMaskIntoConstraints = false
                    upperView.addSubview(containerStackView)
                    NSLayoutConstraint.activate(
                        [
                            containerStackView.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 0),
                            containerStackView.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: 0),
                            NSLayoutConstraint(item: containerStackView,
                                               attribute: .top,
                                               relatedBy: .greaterThanOrEqual,
                                               toItem: upperView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: 0),
                            NSLayoutConstraint(item: upperView,
                                               attribute: .bottom,
                                               relatedBy: .greaterThanOrEqual,
                                               toItem: containerStackView,
                                               attribute: .bottom,
                                               multiplier: 1.0,
                                               constant: 0),
                            containerStackView.centerYAnchor.constraint(equalTo: upperView.centerYAnchor)
                        ]
                    )
                }
                
                
                self.footerView.translatesAutoresizingMaskIntoConstraints = false
                //        self.footerView.setHeight(100)
                
                containerView.addSubview(self.footerView)
                NSLayoutConstraint.activate(
                    [
                        self.footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
                        self.footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
                        self.footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
                    ]
                )
                
                if footerType == .stickyDownBodyTop {
                    NSLayoutConstraint.activate([
                        NSLayoutConstraint(item: footerView,
                                           attribute: .top,
                                           relatedBy: .greaterThanOrEqual,
                                           toItem: upperView,
                                           attribute: .bottom,
                                           multiplier: 1.0,
                                           constant: 0)
                    ])
                } else if footerType == .stickyDownBodyMiddle {
                    NSLayoutConstraint.activate([
                        NSLayoutConstraint(item: footerView,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: upperView,
                                           attribute: .bottom,
                                           multiplier: 1.0,
                                           constant: 0)
                    ])
                }
                
                
                NSLayoutConstraint.activate([
                    NSLayoutConstraint(item: containerView,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: self.scrollView,
                                       attribute: .width,
                                       multiplier: 1.0,
                                       constant: 0)
                ])
                
                let heightConstraint = NSLayoutConstraint(item: containerView,
                                                          attribute: .height,
                                                          relatedBy: .equal,
                                                          toItem: self.scrollView,
                                                          attribute: .height,
                                                          multiplier: 1.0,
                                                          constant: 0)
                
                heightConstraint.priority = UILayoutPriority(250)
                NSLayoutConstraint.activate([
                    heightConstraint
                ])
                
            }
        }
        
        viewModel?.output.topStickedItems = { [weak self] topItems in
            
            let topItems = topItems.reversed()
            for vv in topItems {
                self?.wholeScreenStackView.insertArrangedSubview(vv, at: 0)
            }
        }
        
        viewModel?.output.reloadTableData = { [weak self] footerType in
        
            if let tableView = self?.tableView {

                tableView.reloadData()

            } else if let containerStackView = self?.containerStackView {
                
                containerStackView.removeArrangedSubviews()
                guard let ti = self?.viewModel?.tableItems else { return }

                for tuple in ti {
                    if let sectionView = tuple.0 {
                        containerStackView.addArrangedSubview(sectionView)
                    }
                    for view in tuple.1 {
                        containerStackView.addArrangedSubview(view)
                    }
                }
            }
        }
        
        viewModel?.output.setFooterViews = { [weak self] tuple in
            
            guard let self = self else { return }
            
            let view = tuple.footerView
            view.backgroundColor = .cyan
            let footerType = tuple.footerType

            if footerType == .classicTableFooter {
                // this is not necessary
            } else {
                self.footerView.removeSubviews()
                self.footerView.embed(view)
            }
        }
        
        viewModel?.output.bannerConfig = { [weak self] config in
            DispatchQueue.main.async { [weak self] in
                if let config = config {
                    
                    let bannerChipView = self?.wholeScreenStackView.getBannerView() ?? NotificationBanner(frame: .basic)
//                    bannerChipView.apply(skin: config.skin)
                    if let image = config.icon {
//                        bannerChipView.leftImage(image: config.icon, width: 24, height: 24)
                    }
//                    bannerChipView.text = config.title
                    
                    self?.wholeScreenStackView.addBannerView(bannerChipView, tableView: self?.tableView)
                }
                else {
                    self?.wholeScreenStackView.removeBannerView(tableView: self?.tableView)
                }
            }
        }
        
        viewModel?.output.showSnackBar = { [weak self] text in
            self?.showSnackBar(with: text)
        }
        
        viewModel?.output.showViewFullScreen = { [weak self] view in
            DispatchQueue.main.async { [weak self] in
                self?.view?.hideAlertInfoView()
                self?.view?.showAlertInfoView(view: view)
            }
        }
        
        viewModel?.output.hideViewFullScreen = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.view?.hideAlertInfoView()
            }
        }
        
        viewModel?.output.showViewInList = { [weak self] view in
            DispatchQueue.main.async { [weak self] in
                if let tableView = self?.tableView {
                    
                    tableView.backgroundView = view
                    tableView.reloadData()
                    
                } else if let containerStackView = self?.containerStackView {
                    
                    containerStackView.showView(view)
                }
            }
        }
        
        viewModel?.output.hideViewInList = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                if let tableView = self?.tableView {
                    
                    tableView.backgroundView = nil
                    tableView.reloadData()
                    
                } else if let containerStackView = self?.containerStackView {
                    
                    containerStackView.hideView()
                }
            }
        }
        
        viewModel?.output.tableViewScrollEnabled = { [weak self] state in
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.isScrollEnabled = state
            }
        }
        
        viewModel?.output.setNavButton = { [weak self] model in
            self?.navigationItem.setNavButton(model: model)
        }
        
        viewModel?.output.refreshControlForTableView = { [weak self] in
            guard let self = self else { return }
            
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.tableView?.refreshControl = self.refreshControl
        }
        
        viewModel?.output.showFileGetter = { [weak self] documentPicker in
            guard let self = self else { return }

            documentPicker.delegate = self
            self.present(documentPicker, animated: true)
        }
        
        viewModel?.output.didEndRefreshing = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func pullToRefresh() {
        viewModel?.pullToRefresh()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tableView = self.tableView {
            viewModel?.scrollViewDidEndDecelerating(scrollView, tableView)
        }
    }
    
    @objc
    open func keyboardWillShow(notification: Notification) {
        
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                print("Notification: Keyboard will show")
//                tableView.setBottomInset(to: keyboardHeight)
//                tableView.isKeyboardShown = true
            }
        
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        let keyboardHeight = keyboardSize?.height
        
        
        self.bottomConstraint?.constant = keyboardHeight! - view.safeAreaInsets.bottom
//        
//        print("------ \(self.bottomConstraint?.constant)")
//        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        print("Notification: Keyboard will hide")
//        tableView.setBottomInset(to: 0.0)
//        tableView.isKeyboardShown = false
        
        
        self.bottomConstraint?.constant =  0

        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
}



extension UniViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let header = viewModel?.tableItems[section].0 {
            return header
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if let header = viewModel?.tableItems[section].0 {
            
            return UITableView.automaticDimension
        }
        return 0
    }
    
}

extension UniViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.tableItems.count ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tableItems[section].1.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = viewModel?.tableItems[indexPath.section].1[indexPath.row] else { return UITableViewCell() }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: UniTableViewCell.reuseIdentifier) as? UniTableViewCell else { return UITableViewCell() }
        cell.setup(embedingView: item, tableView: tableView as? UniTableView)

        return cell
    }
}

extension UniViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        viewModel?.input.takenFromFile?(url)
    }
}

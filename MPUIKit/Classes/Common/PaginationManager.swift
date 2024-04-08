//
// PaginationManager
// MPUIKit
//
//  Created by Marian Polek on 06/12/2023.
//  

import Foundation

public protocol CodableWithId: Codable {
    
    var id: String { get set }
}

public protocol PagingItemListResponse: Codable where Element: CodableWithId {
    associatedtype Element
    
    var totalCount: Int { get set }
    var page: Int { get set }
    var pageSize: Int { get set }
    var items: [Element] { get set }
}



public class PaginationManager<T: CodableWithId, H: Error> {
    
    public enum PaginationStateEnum {
        case startedLoading
        case finishedLoading
        case items([CodableWithId], Int)
        case error(Int, H)
        case noInternet(Int)
    }
    
    var page: Int = 1
    var pageSize: Int
    var totalCount: Int = -1
    
    var items: [CodableWithId] = []
    
    var lastRequestedDatetime: Date = Date()
    var isLoadingRequest: Bool = false
    
    public var fetchItems: ((Int, Int, @escaping (CompletionResult<any PagingItemListResponse, H>?) -> ()) -> ())? = nil
    public var statusChanged: ((PaginationStateEnum) -> ())? = nil
    
    private var isConnectedToInternet: (() -> (Bool))?
    
    public init(pageSize: Int = 12,
                isConnectedToInternet: (() -> (Bool))? = nil) {
        self.pageSize = pageSize
        self.isConnectedToInternet = isConnectedToInternet
    }
    
    func didReachEndOfTable() {
        
        if Date() > lastRequestedDatetime && isLoadingRequest == false {
            lastRequestedDatetime = Date().add(.second, amount: 1)
            
            isLoadingRequest = true
            getNextPage(page: self.page + 1)
        } else {
        }
    }
    
    func shouldLoadMore() -> Bool {
        return self.totalCount > self.items.count
    }
    
    public func getFirstPage() {
        
        isLoadingRequest = true
        getNextPage(page: 1, showLoading: true)
    }
    
    func loadPageAtIndex(index: Int) {
        
        isLoadingRequest = true
        getNextPage(page: index)
    }
    
    func getNextPage(page: Int? = nil, pageSize: Int? = nil, showLoading: Bool = false) {
    
        if self.isConnectedToInternet?() == true {
            
            if showLoading == true {
                self.statusChanged?(.startedLoading)
            }
            
            self.fetchItems?(page ?? self.page, pageSize ?? self.pageSize, { [weak self] result in
                
                guard let self = self else { return }
                
                if showLoading == true {
                    self.statusChanged?(.finishedLoading)
                }
                
                self.isLoadingRequest = false

                switch result {
                case .value(let response):
                    
                    if self.totalCount != -1, self.totalCount != response.totalCount {
                        self.loadFirstNotificationsBecauseOfTotalCountChange(abs(self.totalCount - response.totalCount))
                    }
                    
                    if response.totalCount == 0 {
                        self.statusChanged?(.items([], 0))
                        return
                    }
                    
                    self.page = response.page
                    self.totalCount = response.totalCount
                    
                    self.addItemsToList(response.items)
                    self.statusChanged?(.items(self.items,
                                               (self.totalCount <= -1) ? 0 : self.totalCount))
                case .error(let error):
                    self.statusChanged?(.error(self.page, error))
                case .none:
                    break
                }
            })
        } else {
            self.isLoadingRequest = false
            self.statusChanged?(.noInternet(self.page))
        }
        
    }
    
    func loadFirstNotificationsBecauseOfTotalCountChange(_ differenceInTotalCounts: Int) {
        
        getNextPage(page: 1, pageSize: differenceInTotalCounts + 10)
    }
    
    private func addItemsToList(_ items: [CodableWithId]) {
        self.items = self.items
            .filter { listItem in
                return !items.contains(where: { $0.id == listItem.id })
            }
        
        self.items.append(contentsOf: items)
    }
    
    func clearData() {
        page = 1
        totalCount = -1
        items = []
    }
    
    public func pullToRefresh() {
        
        self.clearData()
        self.getNextPage(showLoading: true)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, _ tableView: UITableView) {
        guard (scrollView.contentOffset.y + scrollView.frame.size.height + 1) >= tableView.contentSize.height else { return }
        if self.shouldLoadMore() {
            tableView.tableFooterView = UIView.loadingTableFooterView()
            tableView.scrollRectToVisible(tableView.convert(tableView.tableFooterView?.bounds ?? CGRect(), from: tableView.tableFooterView), animated: true)
            self.didReachEndOfTable()
        } else {
            tableView.tableFooterView = nil
        }
    }
}

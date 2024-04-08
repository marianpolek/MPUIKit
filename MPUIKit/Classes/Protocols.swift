//
//  Protocols.swift
//  MPUIKit
//
//  Created by Marian Polek on 07/04/2024.
//

import Foundation
import UIKit

protocol PaginationViewModelType {
    
    func pullToRefresh()
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, _ tableView: UITableView)
}

protocol PaginationUITableViewDelegate: UITableViewDelegate {
    
}

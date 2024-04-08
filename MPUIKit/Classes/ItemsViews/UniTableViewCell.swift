//
// UniTableViewCell
// MPUIKit
//
//  Created by Marian Polek on 21/02/2024.
//  
//  

import UIKit

protocol UniViewWithTableView {
    
    var tableView: UniTableView? { get set }
}

public protocol UniViewWithInsets: UIView {
    
    var insets: UIEdgeInsets { get set }
    func setup()
}

public extension UniViewWithInsets {
    
    func setup() {}
}

public class UniTableViewCell: UITableViewCell {
    
    var tableView: UniTableView? = nil
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(embedingView: UniViewWithInsets, tableView: UniTableView? = nil) {
        
        self.contentView.backgroundColor = .clear
        self.contentView.removeSubviews()
        self.contentView.embed(embedingView)

        if var ev = embedingView as? UniViewWithTableView {
            ev.tableView = tableView
        }
    }
}

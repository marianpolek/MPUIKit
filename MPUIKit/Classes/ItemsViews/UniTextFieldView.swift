//
// UniTextFieldView
// MPUIKit
//
//  Created by Marian Polek on 29/02/2024.
//  
//  

import Foundation
import UIKit


open class UniTextFieldView: UIView, UniViewWithInsets, UniViewWithTableView {
    
    var tableView: UniTableView?
    
    var title: String
    var placeholder: String? = nil
    var errorString: String?
    public var insets: UIEdgeInsets
    var maxLimit: Int? = nil
    var canPaste: Bool

    var didChangeBlock: ((String?) -> (String?))?
    var didEndBlock: ((String?) -> (String?))?
    
    public init(title: String,
                placeholder: String? = nil,
                errorString: String? = nil,
                didChangeBlock: ( (String?) -> String?)? = nil,
                didEndBlock: ( (String?) -> String?)? = nil,
                maxLimit: Int? = nil,
                canPaste: Bool = false,
                _ insets: UIEdgeInsets = UIEdgeInsets.all20) {
        self.title = title
        self.placeholder = placeholder
        self.errorString = errorString
        self.didChangeBlock = didChangeBlock
        self.didEndBlock = didEndBlock
        self.maxLimit = maxLimit
        self.canPaste = canPaste
        self.insets = insets
        super.init(frame: CGRect.basic)
        
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public func setup() {

        self.removeSubviews()
        
        let textFieldView = UniTextField()
        textFieldView.borderStyle = .line
        
        textFieldView.placeholder = self.placeholder
        
        self.embed(textFieldView, insets: self.insets)
    }
}
  

open class UniTextField: UITextField {
    
    var returnTapped: (() -> ())?
    var editingDidBegin: (() -> ())?
    var editingDidEnd: ((_ textField: UITextField) -> ())?
    var editingDidChanged: ((_ text: String?, _ textField: UITextField) -> ())?
    var shouldChangeCharactersIn: ((_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> (Bool))?
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        self.returnTapped?()
        return false
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.editingDidBegin?()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {

        self.editingDidEnd?(self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
        self.editingDidChanged?(sender.text, self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.shouldChangeCharactersIn?(textField, range, string) ?? true
    }
}

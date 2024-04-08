//
//  BaseViewModel.swift
// MPUIKit
//
//  Created by Marian Polek on 30/09/2020.
//

import Foundation

public typealias Callback<T> = (T) -> Void
public typealias CallbackVoid = () -> Void

public protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output

    var input: Input { get set }
    var output: Output { get set }
    
    func bindInputs()
}

open class BaseViewModel {
    
    
    public init() {
    }
}

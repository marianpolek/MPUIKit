//
//  Date+Extensions.swift
//  MPUIKit
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation

public extension Date {
    
    func add(_ type: Calendar.Component, amount: Int) -> Date {
        
        let calendar = Calendar.current
        var dayComponent = DateComponents()
        dayComponent.setValue(amount, for: type)
        if let success = calendar.date(byAdding: dayComponent, to: self) {
            return success
        }
        return self
    }
}

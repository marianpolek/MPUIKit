//
//  Array+Extensions.swift
//  MPUIKit_example
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation

public extension Array {
    
    func partOfArrayBy(from: Int, to: Int) -> Array {
            
        if from >= self.count { return [] }

        if to > self.count {
            return Array(self[from..<self.count])
        } else {
            return Array(self[from..<to])
        }
    }
}

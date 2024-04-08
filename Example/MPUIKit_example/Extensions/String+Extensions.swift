//
//  String+Extensions.swift
//  MPUIKit_example
//
//  Created by Marian Polek on 08/04/2024.
//

import Foundation

extension String {
    
    static func random(length: Int) -> String {
        return Self.random(range: (length, length))
    }
    
    static func random(range: (Int, Int), spaces: Bool? = true) -> String {

        let length = Int.random(in: range.0...range.1)
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let lettersWithSpaces = "ab cdefg hijkl mnopqrs tuvwxyzA BCDEFGH IJKL MNOPQR STUVWXYZ01 234 56789"
        if spaces == true {
            return String((0..<length).map{ _ in lettersWithSpaces.randomElement()! })
        } else {
            return String((0..<length).map{ _ in letters.randomElement()! })
        }
    }
}

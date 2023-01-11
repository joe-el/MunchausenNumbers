//
//  MunchausenNum.swift
//  MunchausenNumbers
//
//  Created by Kenneth Gutierrez on 12/23/22.
//

import Foundation
import SwiftOxide

class MunchausenNum: ObservableObject {
    @Published var wholeNumbers: [Int]
    
    init() {
        wholeNumbers = []
    }
    
    // Here is how we are searching for Munchausen numbers using Swift Lang.
    func swiftMunchausenNumbers() {
        // Pre-caching the power for all of the digits; 0^0 will be inserted into the cache array.
        let naturalNumbers: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        var cache: [Int] = naturalNumbers.map({ Int(pow(Double($0), Double($0))) })
        cache.insert(0, at: 0)
        
        // Searching for Munchausen numbers iterating through a long range containing all of them.
        for integer in 0...500_000_000 where isMunchausenNumber(integer, cache: cache) {
            wholeNumbers.append(integer)
        }
    }
    
    func isMunchausenNumber(_ number: Int, cache: [Int]) -> Bool {
        var currentNumber = number
        var sum: Int = 0
        
        // The calculation details—Do until we go through all of the digits.
        while currentNumber > 0 {
            // Take the last digit of a number.
            let digit = currentNumber % 10
            // Add the cached power of the digit to the overall sum.
            sum += cache[Int(digit)]
            
            if sum > number {
                return false
            }
            
            // "Cut" the last digit.
            currentNumber /= 10
        }
        
        return sum == number
    }
    
    // And here is how we are searching for Münchhausen numbers using Rust Lang.
    func rustMunchausenNumbers() {
        wholeNumbers = SwiftOxide.rustMunchausenNum()
    }
}

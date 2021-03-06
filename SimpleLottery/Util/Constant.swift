//
//  Constant.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/10.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation

infix operator ^^ : MultiplicationPrecedence

func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

// overflow protection does not exist (lazy face), use with caution
func hashCode(array: [Int]) -> Int64 {
    var result: Int64 = 0
    for i in 0..<array.count {
        result += Int64(array[i]) * Int64(Constant.maxNumber ^^ i)
    }
    return result
}

func unhashCode(code: Int64) -> [Int] {
    var result: [Int] = []
    var p = code
    
    while p > 1 {
        let num = (p - 1) % Int64(Constant.maxNumber) + 1
        result.append(Int(num))
        p = p / Int64(Constant.maxNumber)
    }
    
    return result
}

struct Constant {
    static let maxNumber: Int = 36
    static let priceCount: Int = 6
    static let ticketPrice: Int = 50
    static let ticketReward: [Int] = [0, 20, 50, 300, 1680, 16800, 666666]
    /* num count: 36
     match 1: 43.90% (855036 / 1947792)
     match 2: 21.10% (411075 / 1947792)
     match 3:  4.17% ( 81200 / 1947792)
     match 4:  0.33% (  6525 / 1947792)
     match 5:  0.00% (   180 / 1947792)
     match 6:  0.00% (     1 / 1947792)
     */
}

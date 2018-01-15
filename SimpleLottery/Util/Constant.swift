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

struct Constant {
    static let priceCount: Int = 6
}

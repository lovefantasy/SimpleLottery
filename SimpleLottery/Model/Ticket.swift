//
//  Ticket.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation

class Ticket {
    var selectedNumbers: [Int]
    var matchedIndex: [Int] = []
    var priceNumbers: [Int]?
    var timeTag: Int32
    var isChecked: Bool = false
    
    var timeString: String {
        return String.init(format: "%d/%d/%d", timeTag/10000, (timeTag%10000)/100, timeTag%100)
    }
    
    init(selectedNumbers: [Int], timeTag: Int32) {
        self.selectedNumbers = selectedNumbers
        self.timeTag = timeTag
    }
    
    func check(priceNumbers: [Int]) -> Int {
        guard !isChecked else {
            print("Attempted to check a ticket that was checked")
            return 0
        }
        
        guard priceNumbers.count == selectedNumbers.count else {
            print("Attempted to check a ticket but the count does not match: %d in price, %d in ticket.", priceNumbers.count, selectedNumbers.count)
            return 0
        }
        
        self.priceNumbers = priceNumbers
        var match: [Int] = []
        var index1 = 0, index2 = 0
        while index1 < selectedNumbers.count && index2 < priceNumbers.count {
            if selectedNumbers[index1] < priceNumbers[index2] {
                index1 += 1
            } else if selectedNumbers[index1] > priceNumbers[index2] {
                index2 += 1
            } else {
                match.append(selectedNumbers[index1])
                matchedIndex.append(index1)
                index1 += 1
                index2 += 1
            }
        }
        
        isChecked = true
        return match.count
    }
}

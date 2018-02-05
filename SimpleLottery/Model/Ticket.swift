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
    
    var timeValid: Bool {
        let now = Date.currentDate()
        return now > timeTag
    }
    
    var hashedPriceNumbers: Int64 {
        guard let p = priceNumbers else {
            return 0
        }
        return hashCode(array: p)
    }
    
    var hashedSelectedNumbers: Int64 {
        return hashCode(array: selectedNumbers)
    }
    
    var hashedMatchedIndex: Int32 {
        var r: Int32 = 0
        for i in 0..<matchedIndex.count {
            r += Int32(matchedIndex[i]) * Int32(Constant.priceCount ^^ i)
        }
        return r
    }
    
    init(selectedNumbers: [Int], timeTag: Int32 = Date.currentDate()) {
        self.selectedNumbers = selectedNumbers
        self.timeTag = timeTag
    }
    
    init(hashedSelectedNumbers: Int64, hashedPriceNumbers: Int64, hashedMatchedIndex: Int32, timeTag: Int32, isChecked: Bool) {
        self.isChecked = isChecked
        self.timeTag = timeTag
        self.selectedNumbers = unhashCode(code: hashedSelectedNumbers)

        if isChecked {
            priceNumbers = unhashCode(code: hashedPriceNumbers)
            
            var mi = hashedMatchedIndex
            while mi > 1 {
                let num = mi % Int32(Constant.priceCount)
                matchedIndex.append(Int(num))
                mi = mi / Int32(Constant.priceCount)
            }
        }
    }
    
    func check() -> Int {
        let price = DataLoader.fetchPrice(timeTag: timeTag)
        if price == 0 {
            let randomPrice = Ticket.generateRandomNumber(maxValue: Constant.maxNumber, count: Constant.priceCount)
            DataLoader.addPrice(timeTag: timeTag, priceNum: hashCode(array: randomPrice))
            return check(priceNumbers: randomPrice)
        } else {
            return check(priceNumbers: unhashCode(code: price))
        }
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
        
        self.priceNumbers = priceNumbers.sorted { $1 > $0 }
        var match: [Int] = []
        var index1 = 0, index2 = 0
        while index1 < selectedNumbers.count && index2 < self.priceNumbers!.count {
            if selectedNumbers[index1] < self.priceNumbers![index2] {
                index1 += 1
            } else if selectedNumbers[index1] > self.priceNumbers![index2] {
                index2 += 1
            } else {
                match.append(selectedNumbers[index1])
                matchedIndex.append(index1)
                index1 += 1
                index2 += 1
            }
        }
        
        isChecked = true
        DataLoader.updateTicket(ticket: self)
        return match.count
    }
    
    func dumpDebugInfo() {
        print("===INFO PER TICKET DUMP START===")
        var snString: String = "Selected Number:"
        for i in 0..<selectedNumbers.count {
            snString.append(String(selectedNumbers[i]))
            snString.append(" ")
        }
        print(snString)
        
        if isChecked {
            var pnString: String = "Price Number:"
            for i in 0..<priceNumbers!.count {
                pnString.append(String(priceNumbers![i]))
                pnString.append(" ")
            }
            print(pnString)
            
            var miString: String = "Matched Index:"
            for i in 0..<matchedIndex.count {
                miString.append(String(matchedIndex[i]))
                miString.append(" ")
            }
            print(miString)
        }
        print("====INFO PER TICKET DUMP END====")
    }
}

extension Ticket {
    static func generateRandomNumber(maxValue: Int, count: Int) -> [Int] {
        guard maxValue > count else {
            print("Mis-use of generateRandomNumber, returning null array...")
            return []
        }
        
        var result: [Int] = []
        for _ in 0..<count {
            var number: Int
            repeat {
                number = Int(arc4random_uniform(UInt32(maxValue))) + 1
            } while result.contains(number)
            result.append(number)
        }
        return result
    }
}

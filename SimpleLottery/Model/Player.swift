//
//  Player.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/9.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation

class Player {
    var timeTag: Int32
    var balance: Int {
        didSet {
            save()
        }
    }
    var tickets: [Ticket]
    
    init() {
        self.balance = 1000
        self.tickets = []
        self.timeTag = Date.currentDate()
    }
    
    init(balance: Int, tickets: [Ticket], timeTag: Int32) {
        self.balance = balance
        self.tickets = tickets
        self.timeTag = timeTag
    }
    
    func save() {
        let data = UserDefaults.standard
        data.set(balance, forKey: "balance")
        data.set(timeTag, forKey: "timeTag")
        data.synchronize()
    }
    
    func addTicket(_ ticket: Ticket) {
        tickets.append(ticket)
        DataLoader.addTicket(ticket: ticket)
    }
    
    func addBalance(_ value: Int) {
        balance += value
    }
    
    func getActiveTicketList() -> [Ticket] {
        return tickets.enumerated().flatMap { $0.element.isChecked ? nil : $0.element }
    }
    
    func getTicketHistory() -> [Ticket] {
        return tickets.enumerated().flatMap { $0.element.isChecked ? $0.element : nil }
    }
}

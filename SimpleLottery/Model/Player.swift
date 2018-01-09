//
//  Player.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/9.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation

class Player {
    public var balance: Int
    private var tickets: [Ticket]
    
    init() {
        self.balance = 0
        self.tickets = []
    }
    
    func addTicket(_ ticket: Ticket) {
        tickets.append(ticket)
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

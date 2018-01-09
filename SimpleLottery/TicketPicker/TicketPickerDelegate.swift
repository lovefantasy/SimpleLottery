//
//  TicketPickerDelegate.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation

public protocol TicketPickerDelegate {
    func didConfirmSelectedTicket(selectedNumbers: [Int])
    func didCanceled()
}

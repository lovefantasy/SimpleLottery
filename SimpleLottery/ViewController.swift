//
//  ViewController.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TicketPickerDelegate {
    
    func didConfirmSelectedTicket(selectedNumbers: [Int]) {
//        let ticket = Ticket(selectedNumbers: selectedNumbers, timeTag: Date.currentDate())
//        print("Test: %d", ticket.check(priceNumbers: [1,2,3,4,5,6]))
//        ticketPickerView!.removeFromSuperview()
//        ticketPickerView = nil
    }
    
    func didCanceled() {
//        ticketPickerView!.removeFromSuperview()
//        ticketPickerView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = Player()
        let ticket1 = Ticket(selectedNumbers: [2,3,4,5,6,7], timeTag: 20180110)
        let ticket2 = Ticket(selectedNumbers: [6,11,13,15,16,17], timeTag: 20180110)
        player.addTicket(ticket1)
        player.addTicket(ticket2)
        let mv = MainView(frame: self.view.frame, model: player)
        self.view.addSubview(mv)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


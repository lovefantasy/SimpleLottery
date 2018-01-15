//
//  ViewController.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let data = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = Player()
        let price = [2,5,9,30,31,32]
        let ticket1 = Ticket(selectedNumbers: [2,3,4,5,6,7], timeTag: 20180110)
        let ticket2 = Ticket(selectedNumbers: [6,11,13,15,16,17], timeTag: 20180110)
        let ticket3 = Ticket(selectedNumbers: [1,5,9,16,25,36], timeTag: 20180110)
        let ticket4 = Ticket(selectedNumbers: [2,8,13,19,21,25], timeTag: 20180110)
        let ticket5 = Ticket(selectedNumbers: [6,21,23,25,30,32], timeTag: 20180110)
        ticket3.check(priceNumbers: price)
        ticket4.check(priceNumbers: price)
        ticket5.check(priceNumbers: price)
        player.addTicket(ticket1)
        player.addTicket(ticket2)
        player.addTicket(ticket3)
        player.addTicket(ticket4)
        player.addTicket(ticket5)
        let mv = MainView(frame: self.view.frame, model: player)
        self.view.addSubview(mv)
        
        DataLoader.fetchTickets()
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


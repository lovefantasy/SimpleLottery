//
//  ViewController.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TicketPickerDelegate {
    var ticketPickerView: TicketPickerView?
    
    func didConfirmSelectedTicket(selectedNumbers: [Int]) {
        let ticket = Ticket(selectedNumbers: selectedNumbers, timeTag: Date.currentDate())
        print("Test: %d", ticket.check(priceNumbers: [1,2,3,4,5,6]))
        ticketPickerView!.removeFromSuperview()
        ticketPickerView = nil
    }
    
    func didCanceled() {
        ticketPickerView!.removeFromSuperview()
        ticketPickerView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketPickerView = TicketPickerView(frame: CGRect.init(x: 20, y: 80, width: self.view.frame.size.width-40, height: 200) , count: 36)
        ticketPickerView!.delegate = self
        self.view.addSubview(ticketPickerView!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


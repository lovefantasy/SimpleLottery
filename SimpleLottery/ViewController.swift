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
    var heartbeat = Timer()
    var infoLabel: UILabel?
    
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
        
        ticketPickerView = TicketPickerView(frame: CGRect.init(x: 20, y: 120, width: self.view.frame.size.width-40, height: 200) , count: 36)
        ticketPickerView!.delegate = self
        self.view.addSubview(ticketPickerView!)
        
        infoLabel = UILabel(frame: CGRect.init(x: self.view.frame.size.width/2 - 90, y: 80, width: 180, height: 30))
        infoLabel!.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.view.addSubview(infoLabel!)
        
        heartbeat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHeartbeat), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        heartbeat.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func timerHeartbeat() {
        if let label = infoLabel {
            let time = Date.currentDayTime()
            label.text = String.init(format: "下次開獎 %d:%d:%d", (24-time.hour)%24, (60-time.minute)%60, (60-time.second)%60)
        }
    }
}


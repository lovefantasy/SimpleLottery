//
//  ViewController.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = generatePlayer()
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

    func generatePlayer() -> Player {
        let data = UserDefaults.standard
        
        if let balance = data.object(forKey: "balance") as? Int, let date = data.object(forKey: "timeTag") as? Int32 {
            print("got a valid player")
            let tickets = DataLoader.fetchTickets()
            return Player(balance: balance, tickets: tickets, timeTag: date)
        } else {
            print("first play, generating player...")
            return Player()
        }
    }
}


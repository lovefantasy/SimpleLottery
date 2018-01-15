//
//  MainView.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/9.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView, UITableViewDataSource, UITableViewDelegate, TicketPickerDelegate {
    var model: Player
    var heartbeat = Timer()
    var tableState = true
    var ticketPickerView: TicketPickerView?
    
    // MARK: UI
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect.init(x: self.frame.size.width/2 - 90, y: 80, width: 180, height: 30))
        label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    lazy var buyButton: UIButton = {
        let button = UIButton(frame: CGRect.init(x: 20, y: 120, width: 140, height: 30))
        button.setTitle("買一張", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        return button
    }()
    lazy var ticketSwitch: UIButton = {
        let button = UIButton(frame: CGRect.init(x: 0, y: self.frame.size.height * 0.4 - 30, width: self.frame.size.width / 2.0, height: 30))
        button.setTitle("彩票列表", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .selected)
        button.setBackgroundImage(nil, for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "underline"), for: .selected)
        return button
    }()
    lazy var historySwitch: UIButton = {
        let button = UIButton(frame: CGRect.init(x: self.frame.size.width / 2.0, y: self.frame.size.height * 0.4 - 30, width: self.frame.size.width / 2.0, height: 30))
        button.setTitle("歷史紀錄", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .selected)
        button.setBackgroundImage(nil, for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "underline"), for: .selected)
        return button
    }()
    lazy var ticketTableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: self.frame.size.height * 0.4, width: self.frame.size.width, height: self.frame.size.height * 0.6))
        tv.dataSource = self
        tv.delegate = self
        tv.register(ListCell.self, forCellReuseIdentifier: "ticketCell")
        return tv
    }()
    lazy var historyTableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: self.frame.size.width, y: self.frame.size.height * 0.4, width: self.frame.size.width, height: self.frame.size.height * 0.6))
        tv.dataSource = self
        tv.delegate = self
        tv.register(ListCell.self, forCellReuseIdentifier: "historyCell")
        return tv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder is not implemented")
    }
    
    init(frame: CGRect, model: Player) {
        self.model = model
        super.init(frame: frame)
        
        self.addSubview(historyTableView)
        self.addSubview(ticketTableView)
        self.addSubview(infoLabel)
        self.addSubview(ticketSwitch)
        self.addSubview(historySwitch)
        self.addSubview(buyButton)
        
        ticketSwitch.isSelected = true
        ticketSwitch.addTarget(self, action: #selector(switchTableView(_:)), for: .touchUpInside)
        historySwitch.addTarget(self, action: #selector(switchTableView(_:)), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(popTicketPicker), for: .touchUpInside)
        
        heartbeat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHeartbeat), userInfo: nil, repeats: true)
    }
    
    @objc func popTicketPicker() {
        ticketPickerView = TicketPickerView(frame: CGRect.init(x: 10, y: 50, width: self.frame.size.width-20, height: (self.frame.size.width-20) * 0.6), count: 36)
        ticketPickerView!.delegate = self
        self.addSubview(ticketPickerView!)
    }
    
    @objc func timerHeartbeat() {
        let time = Date.currentDayTime()
        infoLabel.text = String.init(format: "下次開獎 %d:%2d:%2d", (24-time.hour)%24, (60-time.minute)%60, (60-time.second)%60)
    }
    
    @objc func switchTableView(_ sender: UIButton) {
        if sender == ticketSwitch && !tableState {
            tableState = !tableState
            ticketSwitch.isSelected = true
            historySwitch.isSelected = false
            animatedSwitchTableView(1)
        } else if sender == historySwitch && tableState {
            tableState = !tableState
            ticketSwitch.isSelected = false
            historySwitch.isSelected = true
            animatedSwitchTableView(-1)
        }
    }
    
    func animatedSwitchTableView(_ direction: Int) {
        UIView.animate(withDuration: 1.0, animations: {
            self.ticketTableView.frame.origin.x += self.frame.size.width * CGFloat(direction)
            self.historyTableView.frame.origin.x += self.frame.size.width * CGFloat(direction)
        })
    }
    
    func update() {
        historyTableView.reloadData()
        ticketTableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return model.getTicketHistory().count
        } else {
            return model.getActiveTicketList().count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! ListCell
            let tickets = model.getTicketHistory()
            cell.serialLabel.text = String(indexPath.row)
            cell.setupLabelTitle(tickets[indexPath.row])
            cell.checkButton.setTitle(tickets[indexPath.row].timeString, for: .normal)
            cell.checkButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell") as! ListCell
            let tickets = model.getActiveTicketList()
            cell.serialLabel.text = String(indexPath.row)
            cell.setupLabelTitle(tickets[indexPath.row])
            cell.checkButton.setTitle("兌獎", for: .normal)
            cell.checkButton.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
            return cell
        }
    }
    
    func didConfirmSelectedTicket(selectedNumbers: [Int]) {
        let ticket = Ticket(selectedNumbers: selectedNumbers, timeTag: Date.currentDate())
        model.addTicket(ticket)
        update()
        ticketPickerView!.removeFromSuperview()
        ticketPickerView = nil
    }
    
    func didCanceled() {
        ticketPickerView!.removeFromSuperview()
        ticketPickerView = nil
    }
}

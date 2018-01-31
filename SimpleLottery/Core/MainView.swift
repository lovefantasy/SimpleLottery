//
//  MainView.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/9.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView, UITableViewDataSource, UITableViewDelegate, TicketPickerDelegate, CheckDelegate {
    var model: Player
    var heartbeat = Timer()
    var tableState = true
    var ticketPickerView: TicketPickerView?
    var checkView: CheckView?
    
    // MARK: UI
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect.init(x: self.frame.size.width - 200, y: 80, width: 180, height: 30))
        label.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    lazy var goldLabel: UILabel = {
        let label = UILabel(frame: CGRect.init(x: self.frame.size.width - 200, y: 120, width: 180, height: 30))
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
    
    // MARK: Initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder is not implemented")
    }
    
    init(frame: CGRect, model: Player) {
        self.model = model
        super.init(frame: frame)
        
        self.addSubview(historyTableView)
        self.addSubview(ticketTableView)
        self.addSubview(infoLabel)
        self.addSubview(goldLabel)
        self.addSubview(ticketSwitch)
        self.addSubview(historySwitch)
        self.addSubview(buyButton)
        
        goldLabel.text = String.init(format: "存款： %d", model.balance)
        
        ticketSwitch.isSelected = true
        ticketSwitch.addTarget(self, action: #selector(switchTableView(_:)), for: .touchUpInside)
        historySwitch.addTarget(self, action: #selector(switchTableView(_:)), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(popTicketPicker), for: .touchUpInside)
        
        heartbeat = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerHeartbeat), userInfo: nil, repeats: true)
    }
    
    @objc func popTicketPicker() {
//        guard model.balance >= Constant.ticketPrice else {
//            print("balance not enough")
//            return
//        }
        ticketPickerView = TicketPickerView(frame: CGRect.init(x: 10, y: 50, width: self.frame.size.width-20, height: (self.frame.size.width-20) * 0.6))
        ticketPickerView!.delegate = self
        self.addSubview(ticketPickerView!)
    }
    
    @objc func timerHeartbeat() {
        let time = Date.currentDayTime()
        infoLabel.text = String.init(format: "下次開獎 %d:%02d:%02d", (24-time.hour)%24, (60-time.minute)%60, (60-time.second)%60)
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
    
    @objc func checkButtonTapped(_ sender: UIButton) {
        checkTicket(index: sender.tag - 10000)
    }
    
    func checkTicket(index: Int) {
        let tickets = model.getActiveTicketList()
        guard index < tickets.count else {
            print("attempt to check index: \(index), but only \(tickets.count) tickets available")
            return
        }
        let matched = tickets[index].check(priceNumbers: Ticket.generateRandomNumber(maxValue: Constant.maxNumber, count: Constant.priceCount))
        model.addBalance(Constant.ticketReward[matched])
        update()
        
        checkView = CheckView(frame: CGRect.init(x: 50, y: 50, width: self.frame.size.width - 100, height: 200), ticket: tickets[index])
        checkView!.delegate = self
        self.addSubview(checkView!)
    }
    
    func update() {
        goldLabel.text = String.init(format: "存款： %d", model.balance)
        // before i work out on limit of number of cells displayed at the same time, this may cause performance spike
        // so, commented out at the moment...
//        reloadTable(tableView: historyTableView, animated: !tableState)
//        reloadTable(tableView: ticketTableView, animated: tableState)
        historyTableView.reloadData()
        ticketTableView.reloadData()
    }
    
    func reloadTable(tableView: UITableView, animated: Bool) {
        tableView.reloadData()
        if animated {
            let cells = tableView.visibleCells
            let tableHeight: CGFloat = tableView.bounds.size.height
            
            for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            }
            
            var index = 0
            for i in cells {
                let cell: UITableViewCell = i as UITableViewCell
                UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
                index += 1
            }
        }
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
            let count = tickets.count - 1 // sort starting from latest
            cell.serialLabel.text = String(indexPath.row)
            cell.infoLabel.text = String.init(format: "中獎 %d 元", Constant.ticketReward[tickets[count-indexPath.row].matchedIndex.count])
            cell.infoLabel.sizeToFit()
            cell.setupLabelTitle(tickets[count-indexPath.row])
            cell.checkButton.setTitle(tickets[count-indexPath.row].timeString, for: .normal)
            cell.checkButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
            cell.checkButton.isEnabled = false
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ticketCell") as! ListCell
            let tickets = model.getActiveTicketList()
            cell.serialLabel.text = String(indexPath.row)
            cell.infoLabel.text = tickets[indexPath.row].timeValid ? "可以對獎" : "尚未開獎"
            cell.infoLabel.sizeToFit()
            cell.setupLabelTitle(tickets[indexPath.row])
            cell.checkButton.setTitle("兌獎", for: .normal)
            cell.checkButton.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
            // cell.checkButton.isEnabled = tickets[indexPath.row].timeValid
            cell.checkButton.tag = 10000 + indexPath.row
            cell.checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    // MARK: TicketPickerDelegate
    func didConfirmSelectedTicket(selectedNumbers: [Int]) {
        let ticket = Ticket(selectedNumbers: selectedNumbers, timeTag: Date.currentDate())
        model.addTicket(ticket)
        model.addBalance(-Constant.ticketPrice)
        update()
        
        UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseIn, animations: {
            let frame = self.ticketPickerView!.frame
            self.ticketPickerView!.frame = CGRect(x: frame.origin.x, y: frame.origin.y - self.frame.size.height, width: frame.size.width, height: frame.size.height)
        }, completion: { _ in
            self.ticketPickerView!.removeFromSuperview()
            self.ticketPickerView = nil
            
            if (!self.tableState) {
                self.tableState = !self.tableState
                self.ticketSwitch.isSelected = true
                self.historySwitch.isSelected = false
                self.animatedSwitchTableView(1)
            }
        })
    }
    
    func didCanceled() {
        ticketPickerView!.removeFromSuperview()
        ticketPickerView = nil
    }
    
    // MARK: CheckDelegate
    func didConfirmed() {
        UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseIn, animations: {
            let frame = self.checkView!.frame
            self.checkView!.frame = CGRect(x: frame.origin.x - self.frame.size.width, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }, completion: { _ in
            self.checkView!.removeFromSuperview()
            self.checkView = nil
            
            if (self.tableState) {
                self.tableState = !self.tableState
                self.ticketSwitch.isSelected = false
                self.historySwitch.isSelected = true
                self.animatedSwitchTableView(-1)
            }
        })
    }
}

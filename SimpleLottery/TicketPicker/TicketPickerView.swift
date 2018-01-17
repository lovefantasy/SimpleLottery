//
//  TicketPickerView.swift
//  SimpleLottery
//
//  Created by 張智光 on 2018/1/1.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation
import UIKit

class TicketPickerView: UIView {
    var delegate: TicketPickerDelegate?
    var count: Int
    var currentAmount: Int = 0
    var numberButtons: [UIButton] = []
    var submitButton: UIButton
    var cancelButton: UIButton
    var randomButton: UIButton
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder is not implemented!")
    }
    
    init(frame: CGRect, count: Int = Constant.maxNumber) {
        self.count = count
        let viewSize = CGSize(width: frame.size.width, height: frame.size.height)
        let numberButtonInset = viewSize.width / 61.0
        let numberButtonSize = viewSize.width / 12.2
        let remainingHeight = viewSize.height - numberButtonSize * CGFloat(count/10 + 1) - numberButtonInset * CGFloat(count/10 + 2)
        
        if remainingHeight < 50 {
            print("bad width/height ratio while initializing ticket picker, this may result glitched UI.")
        }
        
        let functionButtonWidth = (viewSize.width - 80.0) / 3.0
        let functionButtonHeight = remainingHeight * 0.8
        
        randomButton = UIButton(frame: CGRect(x: 20.0, y: viewSize.height - remainingHeight * 0.9, width: functionButtonWidth, height: functionButtonHeight))
        randomButton.setTitle("隨機選", for: .normal)
        randomButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        submitButton = UIButton(frame: CGRect(x: 40.0 + functionButtonWidth, y: viewSize.height - remainingHeight * 0.9, width: functionButtonWidth, height: functionButtonHeight))
        submitButton.setTitle("送出", for: .normal)
        submitButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        cancelButton = UIButton(frame: CGRect(x: 60.0 + functionButtonWidth * 2, y: viewSize.height - remainingHeight * 0.9, width: functionButtonWidth, height: functionButtonHeight))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        for i in 0...count/10 {
            for j in 0...(i == count/10 ? count%10-1 : 9) {
                let button = UIButton(frame: CGRect(x: numberButtonInset * CGFloat(j+1) + numberButtonSize * CGFloat(j),
                                                    y: numberButtonInset * CGFloat(i+1) + numberButtonSize * CGFloat(i),
                                                    width: numberButtonSize, height: numberButtonSize))
                button.setTitle(String.init(format: "%d", i*10+j+1), for: .normal)
                button.tag = 100+i*10+j+1
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
                button.addTarget(self, action: #selector(numberButtonTapped), for: .touchUpInside)
                numberButtons.append(button)
                self.addSubview(button)
            }
        }
        randomButton.addTarget(self, action: #selector(randomButtonTapped), for: .touchUpInside)
        self.addSubview(randomButton)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        self.addSubview(submitButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.addSubview(cancelButton)
    }
    
    @objc func numberButtonTapped(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            currentAmount -= 1
        } else {
            if currentAmount >= Constant.priceCount {
                // TODO: Alert here
            } else {
                sender.isSelected = true
                sender.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                currentAmount += 1
            }
        }
    }
    
    @objc func submitButtonTapped(sender: UIButton) {
        guard let d = delegate else {
            return
        }
        guard currentAmount == Constant.priceCount else {
            // TODO: Alert here
            return
        }
        var selectedNumbers: [Int] = []
        for i in 0..<count {
            let button = numberButtons[i]
            if button.isSelected {
                selectedNumbers.append(i+1)
            }
        }
        d.didConfirmSelectedTicket(selectedNumbers: selectedNumbers)
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
        guard let d = delegate else {
            return
        }
        d.didCanceled()
    }
    
    @objc func randomButtonTapped(sender: UIButton) {
        let random = Ticket.generateRandomNumber(maxValue: Constant.maxNumber, count: Constant.priceCount)
        
        var index = 0
        while currentAmount < Constant.priceCount {
            let button = numberButtons[random[index]-1]
            if !button.isSelected {
                button.isSelected = true
                button.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                currentAmount += 1
            }
            index += 1
        }
    }
}

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
    var numberButtons: [UIButton] = []
    var submitButton: UIButton
    var cancelButton: UIButton
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder is not implemented!")
    }
    
    init(frame: CGRect, count: Int) {
        self.count = count
        let viewSize = CGSize(width: frame.size.width, height: frame.size.height)
        let numberButtonInset = viewSize.width / 61.0
        let numberButtonSize = viewSize.width / 12.2
        let remainingHeight = viewSize.height - numberButtonSize * CGFloat(count/10 + 1) - numberButtonInset * CGFloat(count/10 + 2)
        
        if remainingHeight < 50 {
            print("bad width/height ratio while initializing ticket picker, this may result glitched UI.")
        }
        
        let functionButtonWidth = viewSize.width / 2.0 - 30.0
        let functionButtonHeight = remainingHeight * 0.8
        
        submitButton = UIButton(frame: CGRect(x: 20.0, y: viewSize.height - remainingHeight * 0.9, width: functionButtonWidth, height: functionButtonHeight))
        submitButton.setTitle("送出", for: .normal)
        cancelButton = UIButton(frame: CGRect(x: viewSize.width / 2.0 + 10.0, y: viewSize.height - remainingHeight * 0.9, width: functionButtonWidth, height: functionButtonHeight))
        cancelButton.setTitle("取消", for: .normal)
        
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        for i in 0...count/10 {
            for j in 0...(i == count/10 ? count%10 : 9) {
                let button = UIButton(frame: CGRect(x: numberButtonInset * CGFloat(j+1) + numberButtonSize * CGFloat(j),
                                                    y: numberButtonInset * CGFloat(i+1) + numberButtonSize * CGFloat(i),
                                                    width: numberButtonSize, height: numberButtonSize))
                button.setTitle(String.init(format: "%d", i*10+j+1), for: .normal)
                button.tag = 100+i*10+j+1
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                button.addTarget(self, action: #selector(numberButtonTapped), for: .touchUpInside)
                numberButtons.append(button)
                self.addSubview(button)
            }
        }
        self.addSubview(submitButton)
        self.addSubview(cancelButton)
        print("end")
    }
    
    @objc func numberButtonTapped(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            sender.isSelected = true
            sender.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
}

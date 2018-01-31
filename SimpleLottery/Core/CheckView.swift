//
//  CheckView.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/31.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation
import UIKit

class CheckView: UIView {
    var delegate: CheckDelegate?
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect.init(x: self.frame.size.width / 2 - 60, y: self.frame.size.height - 40, width: 120, height: 30))
        button.setTitle("確定", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
        return button
    }()
    var ticketLabels: [UILabel] = []
    var coveredView: [UIView] = []
    var priceLabels: [UILabel] = []
    let ticket: Ticket
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder is not implemented")
    }
    
    init(frame: CGRect, ticket: Ticket) {
        self.ticket = ticket
        super.init(frame: frame)
        
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        self.addSubview(confirmButton)
        
        let lSize = frame.size.width / 27
        for i in 0..<Constant.priceCount {
            let label = UILabel(frame: CGRect(x: lSize * CGFloat(2 + i*4), y: 20, width: lSize * 3, height: lSize * 3))
            label.text = String(ticket.selectedNumbers[i])
            label.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            label.layer.borderWidth = 2.0
            label.layer.cornerRadius = 3.0
            label.layer.masksToBounds = true
            label.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.textAlignment = .center
            ticketLabels.append(label)
            self.addSubview(label)
        }
        
        for i in 0..<Constant.priceCount {
            let container = UIView(frame: CGRect(x: lSize * CGFloat(2 + i*4), y: 20 + lSize * 4, width: lSize * 3, height: lSize * 3))
            let cover = UIView(frame: CGRect(x: 0, y: 0, width: lSize * 3, height: lSize * 3))
            cover.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: lSize * 3, height: lSize * 3))
            label.text = String(ticket.priceNumbers![i])
            label.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            label.layer.borderWidth = 2.0
            label.layer.cornerRadius = 3.0
            label.layer.masksToBounds = true
            label.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            label.textAlignment = .center
            coveredView.append(cover)
            priceLabels.append(label)
            container.addSubview(cover)
            self.addSubview(container)
        }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let animationTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: animationTime) {
            self.animate(index: 0)
        }
    }
    
    func animate(index: Int) {
        guard index < Constant.priceCount else {
            UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveLinear, animations: {
                for i in self.ticket.matchedIndex {
                    let bounds = self.ticketLabels[i].bounds
                    self.ticketLabels[i].bounds = CGRect(x: bounds.origin.x - 3, y: bounds.origin.y - 3, width: bounds.size.width + 6, height: bounds.size.height + 6)
                    self.ticketLabels[i].backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                }
            }, completion: { _ in
                self.confirmButton.isEnabled = true
            })
            return
        }
        UIView.transition(from: coveredView[index], to: priceLabels[index], duration: 1.5, options: .transitionFlipFromRight, completion: { _ in
            self.animate(index: index+1)
        })
    }
    
    @objc func confirmButtonTapped(sender: UIButton) {
        guard let d = delegate else {
            return
        }
        d.didConfirmed()
    }
}

public protocol CheckDelegate {
    func didConfirmed()
}

//
//  ListCell.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/9.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation
import UIKit

class ListCell: UITableViewCell {
    lazy var serialLabel: UILabel = { return UILabel(frame: CGRect(x: 10, y: 25, width: 30, height: 30)) }()
    lazy var checkButton: UIButton = { return UIButton(frame: CGRect(x: 230, y: 10, width: self.frame.size.width - 240, height: 30)) }()
    lazy var infoLabel: UILabel = { return UILabel(frame: CGRect(x: 230, y: 40, width: self.frame.size.width - 240, height: 30)) }()
    var ticketLabels: [UILabel] = []
    var priceLabels: [UILabel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func commonInit() {
        self.contentView.addSubview(serialLabel)
        self.contentView.addSubview(checkButton)
        self.contentView.addSubview(infoLabel)
        
        for i in 0..<Constant.priceCount {
            let label = UILabel(frame: CGRect(x: 40 + 30 * CGFloat(i), y: 10, width: 30, height: 30))
            ticketLabels.append(label)
            self.contentView.addSubview(label)
        }
        
        for i in 0..<Constant.priceCount {
            let label = UILabel(frame: CGRect(x: 40 + 30 * CGFloat(i), y: 40, width: 30, height: 30))
            priceLabels.append(label)
            self.contentView.addSubview(label)
        }
    }
    
    func setupLabelTitle(_ ticket: Ticket) {
        for i in 0..<Constant.priceCount {
            ticketLabels[i].text = String(ticket.selectedNumbers[i])
            priceLabels[i].text = ticket.isChecked ? String(ticket.priceNumbers![i]) : "?"
            setupLabelAttr(ticketLabels[i], false)
            setupLabelAttr(priceLabels[i], true)
            
            if ticket.isChecked && ticket.matchedIndex.count > 0 {
                for k in ticket.matchedIndex {
                    ticketLabels[k].backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                }
            }
        }
    }
    
    func setupLabelAttr(_ label: UILabel, _ isHistory: Bool) {
        label.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.layer.borderWidth = 2.0
        label.layer.cornerRadius = 3.0
        label.layer.masksToBounds = true
        label.backgroundColor = isHistory ? #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) : #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        label.textColor = isHistory ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
    }
}

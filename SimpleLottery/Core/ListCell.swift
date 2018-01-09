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
    let uiInset: CGFloat = 10.0
    
    lazy var serialLabel: UILabel = { return UILabel(frame: CGRect(x: uiInset, y: uiInset, width: self.frame.size.height - uiInset * 2.0, height: self.frame.size.height - uiInset * 2.0)) }()
    lazy var checkButton: UIButton = { return UIButton(frame: CGRect(x: self.frame.size.width - uiInset - 100, y: uiInset, width: 100, height: self.frame.size.height - uiInset * 2.0)) }()
    var ticketLabels: [UILabel] = []
    var priceLabels: [UILabel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func commonInit() {
        self.contentView.addSubview(serialLabel)
        self.contentView.addSubview(checkButton)
        checkButton.isHidden = true
    }
}

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
    var selectedNumbers: [Int] = []
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder is not implemented!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

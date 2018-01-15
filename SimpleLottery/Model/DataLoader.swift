//
//  DataLoader.swift
//  SimpleLottery
//
//  Created by Chih-Kuang Chang on 2018/1/15.
//  Copyright © 2018年 HardMode. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataLoader {
    static func addTicket(ticket: Ticket) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Tickets", in: context)
        let newTicket = NSManagedObject(entity: entity!, insertInto: context)
        
        newTicket.setValue(ticket.timeTag, forKey: "timeTag")
        newTicket.setValue(ticket.hashedSelectedNumbers, forKey: "selectedNum")
        newTicket.setValue(ticket.isChecked, forKey: "isChecked")
        if ticket.isChecked {
            newTicket.setValue(ticket.hashedMatchedIndex, forKey: "matchedIndex")
            newTicket.setValue(ticket.hashedPriceNumbers, forKey: "priceNum")
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func fetchTickets() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Tickets")
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "timeTag", ascending: true)]

        do {
            let result = try context.fetch(request)
            
            if result.count == 0 {
                print("database is null now")
            } else {
                for data in result as! [NSManagedObject] {
                    let t = data.value(forKey: "timeTag") as! Int32
                    let sn = data.value(forKey: "selectedNum") as! Int64
                    let chk = data.value(forKey: "isChecked") as! Bool
                    let pn = data.value(forKey: "priceNum") as! Int64
                    let mi = data.value(forKey: "matchedIndex") as! Int32
                    
                    let ticket = Ticket(hashedSelectedNumbers: sn, hashedPriceNumbers: pn, hashedMatchedIndex: mi, timeTag: t, isChecked: chk)
                    ticket.dumpDebugInfo()
                }
            }
        } catch {
            print("Failed")
        }
    }
}

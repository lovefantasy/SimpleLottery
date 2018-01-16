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
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Tickets")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "selectedNum == %ld AND timeTag == %d", ticket.hashedSelectedNumbers, ticket.timeTag)
        
        do {
            let result = try context.fetch(request)
            guard result.count == 0 else {
                print("unique ticket pair already exist in database:")
                ticket.dumpDebugInfo()
                return
            }
        } catch {
            print("add ticket failed at fetching stage")
        }
        
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
    
    static func updateTicket(ticket: Ticket) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Tickets")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "selectedNum == %ld AND timeTag == %d", ticket.hashedSelectedNumbers, ticket.timeTag)
        
        do {
            let result = try context.fetch(request)
            if result.count == 0 {
                print("ticket to be updated does not exist in database")
                print("predicate: \(ticket.hashedSelectedNumbers), \(ticket.timeTag)")
            } else {
                for data in result as! [NSManagedObject] {
                    data.setValue(ticket.timeTag, forKey: "timeTag")
                    data.setValue(ticket.hashedSelectedNumbers, forKey: "selectedNum")
                    data.setValue(ticket.isChecked, forKey: "isChecked")
                    if ticket.isChecked {
                        data.setValue(ticket.hashedMatchedIndex, forKey: "matchedIndex")
                        data.setValue(ticket.hashedPriceNumbers, forKey: "priceNum")
                    }
                }
            }
            
            do {
                try context.save()
            } catch {
                print("update ticket failed at saving stage")
            }
        } catch {
            print("update ticket failed at fetching stage")
        }
    }
    
    static func fetchTickets() -> [Ticket] {
        var tickets: [Ticket] = []
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
                print("fetched \(result.count) ticket(s) in database")
                for data in result as! [NSManagedObject] {
                    let t = data.value(forKey: "timeTag") as! Int32
                    let sn = data.value(forKey: "selectedNum") as! Int64
                    let chk = data.value(forKey: "isChecked") as! Bool
                    let pn = data.value(forKey: "priceNum") as! Int64
                    let mi = data.value(forKey: "matchedIndex") as! Int32
                    
                    let ticket = Ticket(hashedSelectedNumbers: sn, hashedPriceNumbers: pn, hashedMatchedIndex: mi, timeTag: t, isChecked: chk)
                    tickets.append(ticket)
                }
            }
        } catch {
            print("failed to fetch tickets")
        }
        
        return tickets
    }
}

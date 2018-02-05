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
    // MARK: Ticket database
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
            print("failed saving ticket")
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
                    ticket.dumpDebugInfo()
                    tickets.append(ticket)
                }
            }
        } catch {
            print("failed to fetch tickets")
        }
        
        return tickets
    }
    
    // MARK: price database
    static func addPrice(timeTag: Int32, priceNum: Int64) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Prices")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "timeTag == %d", timeTag)
        
        do {
            let result = try context.fetch(request)
            guard result.count == 0 else {
                print("unique price already exist in database:")
                return
            }
        } catch {
            print("add price failed at fetching stage")
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Prices", in: context)
        let newPrice = NSManagedObject(entity: entity!, insertInto: context)
        
        newPrice.setValue(timeTag, forKey: "timeTag")
        newPrice.setValue(priceNum, forKey: "priceNum")
        
        do {
            try context.save()
        } catch {
            print("failed saving price")
        }
    }
    
    static func fetchPrice(timeTag: Int32) -> Int64 {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult> (entityName: "Prices")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if result.count == 0 {
                print("no price for date \(timeTag).")
                return 0
            } else {
                print("price exist for date \(timeTag)")
                for data in result as! [NSManagedObject] {
                    let pn = data.value(forKey: "priceNum") as! Int64
                    return pn
                }
            }
        } catch {
            print("failed to fetch prices")
        }
        return 0
    }
}

//
//  Expense.swift
//  Expenses
//
//  Created by Mihai Costea on 09/12/14.
//  Copyright (c) 2014 Mihai Costea. All rights reserved.
//

import Foundation
import SwiftyJSON

let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    
    return formatter
}()

struct Expense: Printable {
    let expenseId: String?
    let amount: Float
    let type: String
    let date: NSDate
    
    // MARK:- Printable
    
    var description: String {
        return "ID: \(self.expenseId)\nAmount: \(self.amount)\nType: \(self.type)\nDate: \(self.date)"
    }
}

extension Expense {
    static func expenseFromJSON(json: JSON) -> Expense? {
        if json["amount"].float == nil ||
            json["type"].string == nil ||
            json["date"].string == nil ||
            json["_id"].string == nil {
            return nil
        }
        println(json["date"].stringValue)
        if let date = dateFormatter.dateFromString(json["date"].stringValue) {
            return Expense(expenseId: json["_id"].string!, amount: json["amount"].float!, type: json["type"].string!, date: date)
        }
        
        return nil
    }
    
    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        dict["amount"] = self.amount
        dict["type"] = self.type
        dict["date"] = dateFormatter.stringFromDate(self.date)
        
        return dict
    }
}
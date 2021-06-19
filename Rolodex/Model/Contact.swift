//
//  Contact.swift
//  Rolodex
//
//  Created by DJ Satoda on 4/9/20.
//  Copyright © 2020 DJ Satoda. All rights reserved.
//

import Foundation

struct Contact {
    
    let dateCreated : Double
    let name : String
    let id : String
    let notes : [String : Any]
    let reminderDate : Double
    
    init(id: String, dictionary: [String: Any]) {
        self.dateCreated = dictionary["dateCreated"] as? Double ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.id = id
        self.notes = dictionary["notes"] as? [String : Any] ?? ["" : ""]
        self.reminderDate = dictionary["reminderDate"] as? Double ?? 0
    }
}

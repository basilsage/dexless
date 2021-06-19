//
//  Note.swift
//  Rolodex
//
//  Created by DJ Satoda on 4/9/20.
//  Copyright © 2020 DJ Satoda. All rights reserved.
//

import Foundation
import Firebase

struct Note {
    
    let creationDate : Double
    let noteText : String
    let id : String
    
    init(id : String, dictionary: [String: Any]) {
        self.creationDate = dictionary["creationDate"] as? Double ?? 0
        self.noteText = dictionary["noteText"] as? String ?? ""
        self.id = id
    }
}


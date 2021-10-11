//
//  NoteCell.swift
//  Rolodex
//
//  Created by DJ Satoda on 4/9/20.
//  Copyright © 2020 DJ Satoda. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SwipeCellKit

class NoteCell : SwipeTableViewCell {
    var note : Note? {
        didSet {
            
            guard let date = note?.creationDate else {return }
            let nDate = NSDate(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            let formattedDate = dateFormatter.string(from: nDate as Date)
            
            dateLabel.text = "\(formattedDate)"
            noteText.text = note?.noteText
        }
    }
    
    
    let dateLabel : UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = UIColor.gray
        return dateLabel
    }()
    
    let noteText : UILabel = {
        let noteText = UILabel()
        noteText.numberOfLines = 0
        
        return noteText
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(dateLabel)
        addSubview(noteText)
        
        dateLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 17, paddingBottom: 0, paddingRight: 5, width: 0, height: 25)
        
        noteText.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 17, paddingBottom: 15, paddingRight: 15, width: 0, height: 0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  RemindersHeader.swift
//  Rolodex
//
//  Created by DJ Satoda on 6/6/21.
//  Copyright © 2021 DJ Satoda. All rights reserved.
//

import Foundation
import UIKit

protocol RemindersHeaderDelegate {
    func headerAction()
    func completePressed()
}

class RemindersHeader : UITableViewHeaderFooterView {
    
    var delegate : RemindersHeaderDelegate?
    
    var nextReminder: String? {
         didSet {
            guard let reminderText = nextReminder else {return}
            nextReminderLabel.text = "Next Reminder: \(reminderText)"
            
            if reminderText == "No reminder set" {
                self.reminderButton.isSelected   = false
            } else {
                self.reminderButton.isSelected = true
                
            }
         }
     }
    
    var nextReminderLabel : UILabel = {
        let label = UILabel()
        label.text = "Hi"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var reminderButton : UIButton = {
        let raab = UIButton(type: .custom)
        raab.setTitle("Add a reminder", for: .normal)
        raab.setTitle("Complete reminder", for: .selected)
        raab.backgroundColor = UIColor.black
        raab.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        raab.setTitleColor(.white, for: .normal)
        
        
        return raab
    }()
    
    @objc func addButtonPressed() {
        
        if reminderButton.isSelected {
            print("add Button Pressed - complete reminder")
            delegate?.completePressed()
            
        } else {
            print ("add Button Pressed - create reminder")
//            print("RAAB")
            delegate?.headerAction()
        }
        
        

    }    
    
    lazy var completeButton : UIButton = {
        let raab = UIButton(type: .system)
        raab.setTitle("Complete", for: .normal)
        raab.backgroundColor = UIColor.green
        raab.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        raab.setTitleColor(.white, for: .normal)
        return raab
    }()
    
    @objc func completeButtonPressed() {
        delegate?.completePressed()

    }
    
    var datePickerView : UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    //MARK: Initializer
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(reminderButton)
        
        reminderButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 50, paddingLeft: 50, paddingBottom: 50, paddingRight: 50, width: 0, height: 0)
        reminderButton.layer.cornerRadius = 15
        
        addSubview(nextReminderLabel)
        nextReminderLabel.anchor(top: reminderButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 50)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

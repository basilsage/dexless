//
//  ActionFooter.swift
//  Rolodex
//
//  Created by DJ Satoda on 5/31/21.
//  Copyright © 2021 DJ Satoda. All rights reserved.
//

import Foundation
import UIKit

protocol ActionFooterDelegate {
    func footerAction()
}

class ActionFooter : UITableViewHeaderFooterView {
    
    var delegate : ActionFooterDelegate?    
    
    var nextReminder: String? {
         didSet {
            guard let reminderText = nextReminder else {return}
            nextReminderLabel.text = "Next Reminder: \(reminderText)"
         }
     }
    
    var nextReminderLabel : UILabel = {
        let label = UILabel()
        label.text = "Hi"
        return label
    }()
    
    lazy var reminderButton : UIButton = {
        let raab = UIButton(type: .system)
        raab.setTitle("Add a reminder", for: .normal)
        raab.backgroundColor = UIColor.orange
        raab.addTarget(self, action: #selector(requestButtonPressed), for: .touchUpInside)
        raab.setTitleColor(.white, for: .normal)
        return raab
    }()
    
    @objc func requestButtonPressed() {
        print("RAAB")
        delegate?.footerAction()

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
        
        reminderButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 50, paddingLeft: 20, paddingBottom: 50, paddingRight: 20, width: 0, height: 100)
        reminderButton.layer.cornerRadius = 15
        
        addSubview(nextReminderLabel)
        nextReminderLabel.anchor(top: nil, left: leftAnchor, bottom: reminderButton.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
//        addSubview(datePickerView)
//        datePickerView.anchor(top: reminderButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Brian Voong on 3/24/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Firebase


class AddNoteController: UIViewController {
    
    var selectedContact : Contact?
    var selectedDate = Date().timeIntervalSince1970
    
    let dateButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(setDate), for: .touchUpInside)
        return button
    }()
    
    @objc func setDate() {
        
        let myDatePicker: UIDatePicker = UIDatePicker()
        // setting properties of the datePicker
        myDatePicker.datePickerMode = .date
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)

        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.view.addSubview(myDatePicker)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            self.selectedDate = myDatePicker.date.timeIntervalSince1970
            self.updateDateButtonTitle()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
        
    }
    
    let noteTextView: UITextView = {
        let ntv = UITextView()
        ntv.font = UIFont.systemFont(ofSize: 14)
        ntv.backgroundColor = UIColor.white
        ntv.becomeFirstResponder()
        return ntv
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dateButton)
        dateButton.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        
        view.backgroundColor = .white
        
        view.addSubview(noteTextView)
        noteTextView.anchor(top: dateButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)

        updateDateButtonTitle()
        setupNavigationButtons()
        
        
    }
    
    func updateDateButtonTitle() {

        let nDate = NSDate(timeIntervalSince1970: selectedDate)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let formattedDate = dateFormatter.string(from: nDate as Date)
        dateButton.setTitle(formattedDate, for: .normal)
    
    }
    
    func setupNavigationButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
    
    @objc func saveNote() {
        guard let noteText = noteTextView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let selectedContactId = selectedContact?.id else {return}
//
        let userNotesRef = Database.database().reference().child("contactsAdded").child(uid).child(selectedContactId).child("notes")
        let ref = userNotesRef.childByAutoId()
//
            let values = ["noteText": noteText, "creationDate": selectedDate] as [String : Any]

            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }

                print("Successfully saved post to DB")
            }
            
        self.navigationController?.popViewController(animated: true)
    }



}

//
//  PersonDetailController.swift
//  Rolodex
//
//  Created by DJ Satoda on 4/9/20.
//  Copyright © 2020 DJ Satoda. All rights reserved.
//

import Foundation
import Firebase
import SwipeCellKit
import AVFoundation

// instead of using "No reminder set" as the key or password, make a boolean value nextReminderSet
//class ContactDetailController: UITableViewController, SwipeTableViewCellDelegate, ActionHeaderDelegate, RemindersHeaderDelegate {
class ContactDetailController: UITableViewController, SwipeTableViewCellDelegate, RemindersHeaderDelegate {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var selectedContact : Contact?
    var nextReminder : String? = "No reminder set"
    

    //MARK: UI Methods
    func setupNavigationButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Note", style: .plain, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    //MARK: ViewDidLoad / Appear
//    override func viewDidAppear(_ animated: Bool) {        
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchReminder()
        fetchNotes()
        
        navigationItem.title = selectedContact?.name
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: cellId)
        tableView.register(RemindersHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        setupNavigationButtons()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(fetchNotes), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    //MARK: Header Formatting / Actions
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func fetchReminder() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let selectedContactId = selectedContact?.id else {return}
        
        print("Fetching Reminder")
        let ref = Database.database().reference().child("contactsAdded").child(uid).child(selectedContactId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            let reminderDate = dictionaries["reminderDate"]
                
            if reminderDate == nil {
                self.nextReminder = "No reminder set"
                self.tableView.reloadData()
                return
            }
            let nDate = NSDate(timeIntervalSince1970: reminderDate as! TimeInterval)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            let formattedDate = dateFormatter.string(from: nDate as Date)
            self.nextReminder = formattedDate
            
            })
    }
    
    func headerAction() {
        
        // Create Alert Controller for Reminders
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 60  )
        
        // Create Date Picker for Custom Reminder
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
        pickerView.setValue(UIColor.red, forKeyPath: "textColor")
        pickerView.datePickerMode = .date
        pickerView.locale = .current
        vc.view.addSubview(pickerView)
        
        let reminderAlertController = UIAlertController(title: "Create reminder", message: "", preferredStyle: UIAlertController.Style.alert)
        reminderAlertController.setValue(vc, forKey: "contentViewController")
        reminderAlertController.addAction(UIAlertAction(title: "1 day from now", style: .default, handler: { (_) in
            print("submitted")
            print(pickerView.date)
            
            let today = Date()
            let modifiedDate = today.addingTimeInterval(60 * 60 * 24)
            let firebaseDate = modifiedDate.timeIntervalSince1970
            
            // Save to DB
            self.saveReminderDate(submittedDate: firebaseDate)
            
            // Update label
            let dateFormatter = DateFormatter()
            
            // Convert Date to String
            dateFormatter.dateStyle = .medium
            let enteredDate = dateFormatter.string(from: modifiedDate)
            self.nextReminder = enteredDate
            self.tableView.reloadData()
        }))
        
        reminderAlertController.addAction(UIAlertAction(title: "1 week from now", style: .default, handler: { (_) in
            
            let today = Date()
            let modifiedDate = today.addingTimeInterval(60 * 60 * 24 * 7)
            
            let firebaseDate = modifiedDate.timeIntervalSince1970
            
            // Save to DB
            self.saveReminderDate(submittedDate: firebaseDate)
            
            // Update label
            let dateFormatter = DateFormatter()
            
            // Convert Date to String
            dateFormatter.dateStyle = .medium
            let enteredDate = dateFormatter.string(from: modifiedDate)
            self.nextReminder = enteredDate
            self.tableView.reloadData()
        }))
        
        reminderAlertController.addAction(UIAlertAction(title: "Custom date selected above", style: .default, handler: { (_) in
            let firebaseDate = pickerView.date.timeIntervalSince1970
                        
            // Save to DB
            self.saveReminderDate(submittedDate: firebaseDate)
            
            // Update label
            let dateFormatter = DateFormatter()
            
            // Convert Date to String
            dateFormatter.dateStyle = .medium
            let enteredDate = dateFormatter.string(from: pickerView.date)
            self.nextReminder = enteredDate
            self.tableView.reloadData()
        }))
        reminderAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(reminderAlertController, animated: true)

    }
    
    func completePressed() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let selectedContactId = selectedContact?.id else {return}

        let userRemindersRef = Database.database().reference().child("contactsAdded").child(uid).child(selectedContactId).child("reminderDate")
        
        userRemindersRef.removeValue() {(err, ref) in
            if let err = err {
                print("Failed to complete reminder", err)
                return
            }

            print("Successfully completed reminder")
            self.fetchReminder()
            self.tableView.reloadData()
            }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func saveReminderDate(submittedDate: Double?) {
        guard let date = submittedDate else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let selectedContactId = selectedContact?.id else {return}

        let userRemindersRef = Database.database().reference().child("contactsAdded").child(uid).child(selectedContactId).child("reminderDate")
        userRemindersRef.setValue(date) {(err, ref) in
            if let err = err {
                print("Failed to save date to DB", err)
                return
            }

            print("Successfully saved date to DB")
        }
        
    }
    

    //MARK: Firebase - CRUD Notes
    var notes = [Note]()
    var sortedNotes = [Note]()
    
    @objc func fetchNotes() {
        
        // Don't allow row selections while notes fetching (else crashes)
        self.tableView.allowsSelection = false
        
        notes.removeAll()
        sortedNotes.removeAll()
                
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let selectedContactId = selectedContact?.id else {return}
        
        let ref = Database.database().reference().child("contactsAdded").child(uid).child(selectedContactId).child("notes")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                // without this extra reload data, reminders don't load for Contacts with no notes saved. 
                self.tableView.reloadData()
                return
            }

            dictionaries.forEach({ (key, value) in

                guard let dictionary = value as? [String: Any] else { return }
                
                let note = Note(id: key, dictionary: dictionary)
                self.notes.append(note)
                self.sortedNotes = self.notes.sorted(by: { $0.creationDate > $1.creationDate })

           })
            
            self.tableView.reloadData()

        }) { (err) in
            print("Failed to fetch notes:", err)
        }
        
        // re-enable row selections once notes finish fetching (else crashes)
        refreshControl?.endRefreshing()
        self.tableView.allowsSelection = true
    }

    
    @objc func addNote() {
        let addNoteController = AddNoteController()
        addNoteController.selectedContact = self.selectedContact
        navigationController?.pushViewController(addNoteController, animated: true)
    }
    
    //MARK: UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NoteCell
        cell.delegate = self
        cell.note = sortedNotes[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editNoteController = EditNoteController()
        editNoteController.selectedNote = sortedNotes[indexPath.row]
        editNoteController.selectedContact = selectedContact
        editNoteController.selectedDate = sortedNotes[indexPath.row].creationDate
        
        navigationController?.pushViewController(editNoteController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! RemindersHeader
        headerView.delegate = self
        headerView.nextReminder = self.nextReminder
        headerView.contentView.backgroundColor = .white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let selectedNoteId = self.sortedNotes[indexPath.row].id
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            guard let selectedPersonId = self.selectedContact?.id else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let userRef = Database.database().reference().child("contactsAdded").child(uid).child(selectedPersonId).child("notes").child(selectedNoteId)
            
            userRef.removeValue { (error, ref) in
                if let error = error {
                    print("Uh Oh: ", error)
                } else {
                    print("Succesfully removed")
                    self.fetchNotes()
                }
            }
        }             
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
}

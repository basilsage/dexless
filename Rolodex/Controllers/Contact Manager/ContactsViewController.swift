//
//  ViewController.swift
//  Rolodex
//
//  Created by DJ Satoda on 4/9/20.
//  Copyright © 2020 DJ Satoda. All rights reserved.


import UIKit
import Firebase
import SwipeCellKit
import UserNotifications

class ContactsViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    let cellId = "cellId"
    var contacts = [Contact]()
    var sortedContacts = [Contact]()

        
    override func viewDidAppear(_ animated: Bool) {
        fetchContacts()
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        // if user not logged in
        if Auth.auth().currentUser == nil {
            // present login controller
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        view.backgroundColor = .white
        setupNavigationButtons()
        
    }
    
    //MARK: Firebase CRUD Functions
    
    
    func updateContact(selectedContactId: String, selectedContactName: String) {
        
        print(selectedContactId)
        print(selectedContactName)
        
        let alertController = UIAlertController(title: "Update Contact", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = selectedContactName
        }
        let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in

            guard let contactName = alertController.textFields![0].text else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let userRef = Database.database().reference().child("contactsAdded").child(uid).child(selectedContactId)
            
            let values = ["name": contactName]

            userRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save updated name to DB", err)
                    return
                }

                print("Successfully saved updated name to DB")
                self.dismiss(animated: true, completion: nil)
            }

            self.fetchContacts()
        }

        alertController.addAction(confirmAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)

    }
    
    func deleteContact(selectedContact: String) {
        let alertController = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            let selectedPersonId = selectedContact
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userRef = Database.database().reference().child("contactsAdded").child(uid).child(selectedPersonId)
            
            userRef.removeValue { (error, ref) in
                if let error = error {
                    
                    print("Uh Oh: ", error)
                } else {
                    print("Succesfully removed")
                    self.fetchContacts()
                }
            }
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func addContact() {
          
        let alertController = UIAlertController(title: "Add Contact", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Daisy Lee"
            textField.autocapitalizationType = .words
            
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            guard let contactName = alertController.textFields![0].text else { return }
            print(contactName)
            guard let uid = Auth.auth().currentUser?.uid else { return }

            let userContactsRef = Database.database().reference().child("contactsAdded").child(uid)
            let ref = userContactsRef.childByAutoId()

            let values = ["name": contactName, "dateCreated": Date().timeIntervalSince1970] as [String : Any]

            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to save post to DB", err)
                    return
                }

                print("Successfully saved post to DB")
                self.dismiss(animated: true, completion: nil)
            }
            
            self.fetchContacts()
        }
        
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func fetchContacts() {
        
        // clear arrays to refresh
        contacts.removeAll()
        sortedContacts.removeAll()
        
        // create reference to current user's record in Firebase
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("contactsAdded").child(uid)
        
        // get a snapshot of all data associated with current user
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            // for each record
            dictionaries.forEach({ (key, value) in
            
                guard let dictionary = value as? [String: Any] else { return }
                let contact = Contact(id: key, dictionary: dictionary)
                self.contacts.append(contact)
                self.sortedContacts = self.contacts.sorted(by: { $0.name < $1.name })
           })
            
            self.tableView.reloadData()
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    
    //MARK: Navgation Buttons
    func setupNavigationButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Contact", style: .plain, target: self, action: #selector(addContact))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    
    @objc func openSettings() {
        let alertController = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Allow notifications", style: .default, handler: { _ in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Snooze notification", style: .default, handler: { _ in
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }))
        
        alertController.addAction(UIAlertAction(title: "Create daily notification", style: .default, handler: { _ in
            let content = UNMutableNotificationContent()
            content.title = "Daily Reminder (9pm)"
            content.body = "Add a note / contact"
            content.badge = 1
//            UIApplication.shared.registerForRemoteNotifications()
//            UIApplication.shared.applicationIconBadgeNumber = 1
            content.sound = UNNotificationSound.default
            
            var date = DateComponents()
            date.hour = 21
            date.minute = 0
//            date.second = 50
            let calTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: calTrigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }))
        
        
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: UITableView Delegate Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        let name = sortedContacts[indexPath.row].name
        cell.textLabel?.text = name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContacts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactDetailController = ContactDetailController()
        contactDetailController.selectedContact = sortedContacts[indexPath.row]
        
        navigationController?.pushViewController(contactDetailController, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: SwipeCellKit Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // Delete
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let selectedPersonId = self.sortedContacts[indexPath.row].id
            self.deleteContact(selectedContact: selectedPersonId)
        }
        deleteAction.image = UIImage(named: "delete")
        
        // Change Contact Name
        let updateContactNameAction = SwipeAction(style: .default, title: "Update") { action, indexPath in
            let selectedPersonId = self.sortedContacts[indexPath.row].id
            let selectedPersonName = self.sortedContacts[indexPath.row].name
//            self.deleteContact(selectedContact: selectedPersonId)
            self.updateContact(selectedContactId: selectedPersonId, selectedContactName: selectedPersonName)
            
        }

        return [deleteAction, updateContactNameAction]
    }
    

}



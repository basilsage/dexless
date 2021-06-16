//
//  ExecutiveViewController.swift
//  Rolodex
//
//  Created by DJ Satoda on 6/6/21.
//  Copyright © 2021 DJ Satoda. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwipeCellKit


class ExecutiveViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        fetchActiveContacts()
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    let cellId = "cellId"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ExecutiveViewTableCell
//        cell.textLabel?.text = sortedContacts[indexPath.row].name
        cell.nameLabel.text = sortedContacts[indexPath.row].name
        
        let fetchedDate = sortedContacts[indexPath.row].reminderDate

        let doubleDate = fetchedDate
//            NSDate(timeIntervalSince1970: fetchedDate )
        let currentDate = Date().timeIntervalSince1970
            
        


        
        let nDate = NSDate(timeIntervalSince1970: fetchedDate )
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: nDate as Date)
        
        cell.dueDateLabel.text = formattedDate
//        cell.backgroundColor = .blue
        
        if doubleDate >= currentDate {
            cell.dueDateLabel.textColor = UIColor.gray
        } else if doubleDate < currentDate {
            cell.dueDateLabel.textColor = UIColor.red
        }
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contactDetailController = ContactDetailController()
        contactDetailController.selectedContact = sortedContacts[indexPath.row]


        navigationController?.pushViewController(contactDetailController, animated: true)
        
        
    }

    

    let actionItemsTableView : UITableView = {
        let aitv = UITableView()
        return aitv
    }()
    
    
    let noteTextView: UILabel = {
        let ntv = UILabel()
        ntv.font = UIFont.systemFont(ofSize: 30)
        ntv.text = "Welcome, boss."
        ntv.textAlignment = .center
        ntv.textColor = .black
        
        return ntv
    }()
    let subTitleLabel: UILabel = {
        let ntv = UILabel()
        ntv.font = UIFont.systemFont(ofSize: 15)
        ntv.text = "Active reminders below."
        ntv.textAlignment = .center
        ntv.textColor = .lightGray
        
        return ntv
    }()

    
    let completionTextView: UILabel = {
        let ntv = UILabel()
        ntv.font = UIFont.systemFont(ofSize: 15)
        ntv.text = "You've completed all reminders 😎"
        ntv.textAlignment = .center
        ntv.textColor = .black
        return ntv
    }()
    
    let completionImage : UIImageView = {
        let ci = UIImageView()
        ci.image = UIImage(named: "confetti")
        ci.backgroundColor = .red
        return ci
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
//        self.navigationController?.isNavigationBarHidden = true
        
        
        view.addSubview(noteTextView)
        noteTextView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 200, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        view.addSubview(subTitleLabel)
        (subTitleLabel).anchor(top: noteTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(completionTextView)
        completionTextView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 300, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(actionItemsTableView)
        actionItemsTableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 300, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        actionItemsTableView.dataSource = self
        actionItemsTableView.delegate = self
        actionItemsTableView.register(ExecutiveViewTableCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    
    
    //MARK: Firebase Functions
    
    var contacts = [Contact]()
    var sortedContacts = [Contact]()
    
    func fetchActiveContacts() {
        
        print("fetchActiveContacts()")
        
        contacts.removeAll()
        sortedContacts.removeAll()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let contactsRef = Database.database().reference().child("contactsAdded").child(uid)
        let desiredContactQuery = contactsRef.queryOrdered(byChild: "reminderDate").queryStarting(atValue: 0)
        
        
        desiredContactQuery.observeSingleEvent(of: .value) { (snapshot) in
                        
            guard let dictionaries = snapshot.value as? [String: Any] else {
                print("No contacts have reminders")
//                self.actionItemsTableView.reloadData()
                self.actionItemsTableView.isHidden = true
                return
            }
            
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
               
                let contact = Contact(id: key, dictionary: dictionary as! [String : Any])
                self.contacts.append(contact)
                
                self.sortedContacts = self.contacts.sorted(by: { $0.reminderDate < $1.reminderDate })
//                print("SC: ", self.sortedContacts)
            }
            
            if self.sortedContacts.count == 0 {
//                print("Count = 3")
                self.actionItemsTableView.isHidden = true
            } else {
                self.actionItemsTableView.isHidden = false
                self.actionItemsTableView.reloadData()
            }
            
            
            
            
            
        }
    }
    
    
}

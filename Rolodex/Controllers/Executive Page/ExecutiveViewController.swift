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
        cell.nameLabel.text = sortedContacts[indexPath.row].name
        
        let fetchedDate = sortedContacts[indexPath.row].reminderDate

        let doubleDate = fetchedDate
        let currentDate = Date().timeIntervalSince1970

        let nDate = NSDate(timeIntervalSince1970: fetchedDate )
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: nDate as Date)
        
        cell.dueDateLabel.text = formattedDate
        
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
        ci.backgroundColor = .red
        return ci
    }()
    
    let loadingImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "contacts")
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let loadingView : UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        
        return view
    }()
    
    let backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    
    let shimmerTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Shimmer"
        label.font = UIFont.systemFont(ofSize: 88, weight: .regular)
        label.textColor = UIColor(white: 1, alpha: 0.9)
        label.textAlignment = .center
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Shimmer"
        label.font = UIFont.systemFont(ofSize: 88, weight: .regular)
        label.textColor = UIColor(white: 1, alpha: 0.1)
        label.textAlignment = .center
        return label
    }()
    
    let shimmerViewLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let viewLabel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let shimmerViewLabel2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let viewLabel2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    
//    let textLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Shimmer"
//        label.font = UIFont.systemFont(ofSize: 88, weight: .regular)
//        label.textColor = UIColor(white: 1, alpha: 0.1)
//        label.textAlignment = .center
//        return label
//    }()
    
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
        
        
        view.addSubview(backgroundView)
        backgroundView.anchor(top: actionItemsTableView.topAnchor, left: actionItemsTableView.leftAnchor, bottom: actionItemsTableView.bottomAnchor, right: actionItemsTableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let loadingView = UIImageView(image: UIImage(named: "eclipse.gif"))
        
        backgroundView.addSubview(loadingView)
        loadingView.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 50, paddingRight: 20, width: 0, height: 0)
        
        
//        let shimmerView = Shimm/eringView()
////        shimmerView.backgroundColor = .orange
//        backgroundView.addSubview(myShimmerView)
//        myShimmerView.backgroundColor = .orange
//        myShimmerView.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 50, paddingRight: 20, width: 0, height: 0)
//
//        self.myShimmerView.addSubview(loadingView)
//
//        loadingView.anchor(top: myShimmerView.topAnchor, left: myShimmerView.leftAnchor, bottom: myShimmerView.bottomAnchor, right: myShimmerView.rightAnchor, paddingTop: 150, paddingLeft: 150, paddingBottom: 150, paddingRight: 150, width: 0, height: 0)
//
////        let view = UIView(frame: myShimmerView.bounds)
////        view.backgroundColor = .white
//
//        myShimmerView.contentView = loadingView
//

//
//
//
//        view.addSubview(loadingImage)
//        shimmerView.contentView = loadingImage
////        loadingImage.anchor(top: actionItemsTableView.topAnchor, left: actionItemsTableView.leftAnchor, bottom: actionItemsTableView.bottomAnchor, right: actionItemsTableView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//        myShimmerView.isShimmering = true
        
        
        
        
        
        
        // 6.29
//        backgroundView.addSubview(viewLabel)
//        backgroundView.addSubview(shimmerViewLabel)
//        viewLabel.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: 50)
//        shimmerViewLabel.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: 50)
//
//        backgroundView.addSubview(viewLabel2)
//        backgroundView.addSubview(shimmerViewLabel2)
//        viewLabel2.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 50)
//        shimmerViewLabel2.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 50)
//
//        let gradient = CAGradientLayer()
//        gradient.frame = backgroundView.bounds
////        viewLabel.bounds
//
//        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
//        gradient.locations = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
//        let angle = -60 * CGFloat.pi / 180
//        gradient.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
//
//        shimmerViewLabel.layer.mask = gradient
//
//        let animation = CABasicAnimation(keyPath: "transform.translation.x")
//        animation.duration = 2
//        animation.repeatCount = Float.infinity
//        animation.autoreverses = false
//        animation.fromValue = -view.frame.width
//        animation.toValue = view.frame.width
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = CAMediaTimingFillMode.forwards
//
//        gradient.add(animation, forKey: "shimmerKey")
    }
    
    
    
    
    
    func callbackDismiss() {
        print("Dismissed")
    }

    
    //MARK: Firebase Functions
    
    var contacts = [Contact]()
    var sortedContacts = [Contact]()
    
    func fetchActiveContacts() {
        
//        self.actionItemsTableView.backgroundColor = .gray
        self.backgroundView.isHidden = false
        
        contacts.removeAll()
        sortedContacts.removeAll()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let contactsRef = Database.database().reference().child("contactsAdded").child(uid)
        let desiredContactQuery = contactsRef.queryOrdered(byChild: "reminderDate").queryStarting(atValue: 0)
        
        
        desiredContactQuery.observeSingleEvent(of: .value) { (snapshot) in
                        
            guard let dictionaries = snapshot.value as? [String: Any] else {
                print("No contacts have reminders")
                self.actionItemsTableView.isHidden = true
                return
            }
            
            dictionaries.forEach { (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
               
                let contact = Contact(id: key, dictionary: dictionary)
                self.contacts.append(contact)
                
                self.sortedContacts = self.contacts.sorted(by: { $0.reminderDate < $1.reminderDate })
            }
            
            if self.sortedContacts.count == 0 {
//                print("Count = 3")
                self.actionItemsTableView.isHidden = true
            } else {
                self.actionItemsTableView.isHidden = false
                self.actionItemsTableView.reloadData()
//                self.actionItemsTableView.backgroundColor = .cyan
                self.backgroundView.isHidden = true
            }
            
        }
    }
    
    
}

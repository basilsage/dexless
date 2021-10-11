//
//  MainTabBarController.swift
//  Rolodex
//
//  Created by DJ Satoda on 6/6/21.
//  Copyright © 2021 DJ Satoda. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        // If no user logged in, present Login Controller
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            setupViewControllers()
        }
        setupViewControllers()
        self.tabBar.tintColor = .black
    }
    
    //MARK: Setup View Controllers
    
    // Initialize the two view controllers
    func setupViewControllers() {
                    
        let homeNavController = templateNavController(unselectedImage: UIImage(named: "contacts.png")!, selectedImage: UIImage(named: "contacts.png")!, rootViewController: ContactsViewController())
        let executiveNavController = templateNavController(unselectedImage: UIImage(named: "checklist.png")!, selectedImage: UIImage(named: "checklist.png")!, rootViewController: ExecutiveViewController())
        viewControllers = [executiveNavController, homeNavController]
        
        //Center tab bar item insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 8, left: 4, bottom: -8, right: 4)
        }
    }
    
    // Helper function to initialize view controllers
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
}

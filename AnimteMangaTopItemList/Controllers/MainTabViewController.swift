//
//  MainTabViewController.swift
//  AnimteMangaTopItemList
//
//  Created by David on 2020/11/22.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewControllers()
  }
  
  func configureViewControllers() {
    let homeVC = HomeViewController()
    homeVC.tabBarItem.title = "Home"
    homeVC.tabBarItem.image = UIImage(named: "home")
    
    let favoritesVC = FavoritesViewController()
    favoritesVC.tabBarItem.title = "Favorites"
    favoritesVC.tabBarItem.image = UIImage(named: "heart")
    
    viewControllers = [homeVC, favoritesVC]
  }
}

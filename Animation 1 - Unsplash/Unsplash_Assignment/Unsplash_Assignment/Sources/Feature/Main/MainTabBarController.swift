//
//  MainTabBarController.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/07.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let photoListViewController = PhotoListViewController.init(PhotoListViewModel())
    private let searchViewController = SearchViewController.init(SearchViewModel())
    private let dummyViewController1 = ViewController.init()
    private let dummyViewController2 = ViewController.init()
    
    private let photoListTabBarItem = UITabBarItem(title: nil,
                                              image: UIImage.init(systemName: "photo.fill"), tag: 0)
    private let searchTabBarItem = UITabBarItem(title: nil,
                                                image: UIImage.init(systemName: "magnifyingglass"), tag: 1)
    private let dummyTabBarItem1 = UITabBarItem(title: nil,
                                              image: UIImage.init(systemName: "photo.fill"), tag: 0)
    private let dummyTabBarItem2 = UITabBarItem(title: nil,
                                              image: UIImage.init(systemName: "photo.fill"), tag: 0)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
       
        photoListViewController.tabBarItem = photoListTabBarItem
        searchViewController.tabBarItem = searchTabBarItem
        dummyViewController1.tabBarItem = dummyTabBarItem1
        dummyViewController2.tabBarItem = dummyTabBarItem2

        dummyTabBarItem1.isEnabled = false
        dummyTabBarItem2.isEnabled = false
        
        let controllers = [photoListViewController, searchViewController, dummyViewController1, dummyViewController2]
        viewControllers = controllers
    }
    
}

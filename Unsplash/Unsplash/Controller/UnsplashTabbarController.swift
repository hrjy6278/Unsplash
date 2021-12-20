//
//  UnsplashTabbarController.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import UIKit

class UnsplashTabbarController: UITabBarController {

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Unsplash"
        configure()
    }
}

//MARK: - Method
extension UnsplashTabbarController {
    private func configure() {
        let searchViewController = SearchViewController()
        let searchImage = UIImage(systemName: "magnifyingglass.circle")
        let searchTapImage = UIImage(systemName: "magnifyingglass.circle.fill")
        searchViewController.tabBarItem = UITabBarItem(title: "Search",
                                                       image: searchImage,
                                                       selectedImage: searchTapImage)
    
        viewControllers = [
            searchViewController
        ]
    }
}

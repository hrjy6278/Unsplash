//
//  UnsplashTabbarController.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import UIKit

class UnsplashTabbarController: UITabBarController {
    
    private lazy var loginButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Login"
        button.target = self
        button.action = #selector(didTapLoginButton(_:))
        
        return button
    }()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
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
    
    private func configureNavigation() {
        navigationItem.title = "Unsplash"
        navigationItem.rightBarButtonItem = loginButton
        navigationController?.navigationBar.backgroundColor = .gray
    }
    
    @objc func didTapLoginButton(_ sender: UIBarButtonItem) {
        //MARK: Todo 로그인 Page 보여주기 새로운 흐름이니 모달로?
        debugPrint(#function)
    }
}

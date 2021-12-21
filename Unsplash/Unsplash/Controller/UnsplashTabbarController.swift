//
//  UnsplashTabbarController.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import UIKit

class UnsplashTabbarController: UITabBarController {
    //MARK: Properties
    private lazy var loginButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.target = self
        button.action = #selector(didTapLoginButton(_:))
        
        return button
    }()
    
    private var searchViewController: SearchViewController = {
        let searchViewController = SearchViewController()
        let searchBarNomalImage = UIImage(systemName: "magnifyingglass.circle")
        let searchBarTapedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        searchViewController.tabBarItem = UITabBarItem(title: "Search",
                                                       image: searchBarNomalImage,
                                                       selectedImage: searchBarTapedImage)
        
        return searchViewController
    }()
    
    private var isTokenSaved: Bool {
        TokenManager.shared.isTokenSaved ? true : false
    }
    
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
        viewControllers = [
            searchViewController
        ]
    }
    
    private func configureNavigation() {
        navigationItem.title = "Unsplash"
        navigationItem.rightBarButtonItem = loginButton
        navigationItem.rightBarButtonItem?.title = isTokenSaved ? "로그아웃" : "로그인"
        navigationController?.navigationBar.backgroundColor = .gray
    }
    
    @objc func didTapLoginButton(_ sender: UIBarButtonItem) {
        if isTokenSaved {
            //MARK: ToDo 정상적으로 로그아웃됐다고 얼러트를 띄워주기
            TokenManager.shared.clearAccessToken()
            navigationItem.rightBarButtonItem?.title = "로그인"
        } else {
            navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
}

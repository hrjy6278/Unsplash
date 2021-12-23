//
//  ProfileViewController.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/22.
//

import UIKit

class ProfileViewController: UIViewController, TabBarImageInfo {
    //MARK: Properties
    var nomal = "person"
    var selected = "person.fill"
    var barTitle = "Profile"
    
    private let networkService = UnsplashAPIManager()
    private let tableViewdataSource = ImageListDataSource()
    private let tableViewHeaderView = ProfileHeaderView()
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImageListTableViewCell.self,
                           forCellReuseIdentifier: ImageListTableViewCell.cellID)
        
        return tableView
    }()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        configureTableView()
        fetchUserProfile()
    }
}

//MARK: - Setup View And Layout
extension ProfileViewController: HierarchySetupable {
    func setupViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Configure Views
extension ProfileViewController {
    func configureTableView() {
        tableViewHeaderView.frame.size.height = view.frame.size.height / 8
        tableView.rowHeight = view.frame.size.height / 4
        tableView.tableHeaderView = tableViewHeaderView
        tableView.dataSource = tableViewdataSource
        tableView.delegate = tableViewdataSource
    }
}

//MARK: - NetworkService
extension ProfileViewController {
    func fetchUserProfile() {
        networkService.fetchUserProfile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.tableViewHeaderView.configure(selfieURL: profile.profileImage?.mediumURL,
                                                   name: profile.userName)
                self.fetchUserLikePhotos(userID: profile.userName ?? "")
            case .failure(let error):
                debugPrint("좋아하는 사진 가져오기 실패", error)
            }
        }
    }
    
    func fetchUserLikePhotos(userID: String) {
        networkService.fetchUserLikePhotos(userName: userID) { result in
            switch result {
            case .success(let photos):
                self.tableViewdataSource.photos = photos
                self.tableView.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

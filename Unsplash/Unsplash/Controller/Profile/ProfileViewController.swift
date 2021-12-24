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
    
    private var page = 1
    private var userName = ""
    
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
        tableViewdataSource.delegate = self
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
                self.fetchUserLikePhotos(userName: profile.userName)
                self.userName = profile.userName
            case .failure(let error):
                debugPrint("좋아하는 사진 가져오기 실패", error)
            }
        }
    }
    
    func fetchUserLikePhotos(userName: String) {
        networkService.fetchUserLikePhotos(userName: userName, page: self.page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photos):
                photos.forEach { self.tableViewdataSource.photos.append($0) }
                self.tableView.reloadData()
                self.page += 1
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

//MARK: - ImageList DataSource Delegate
extension ProfileViewController: ImageListDataSourceDelegate {
    func morePhotos() {
        fetchUserLikePhotos(userName: userName)
    }
    
    func didTapedLikeButton(photoId: String) {
        print("사용하지않는버튼입니다.")
    }
}

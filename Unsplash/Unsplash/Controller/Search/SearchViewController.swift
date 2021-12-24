//
//  ViewController.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Properties
    private let networkService = UnsplashAPIManager()
    private let tableViewDataSource = ImageListDataSource()
    private var page: Int = 1
    private var query: String = ""
    private var photos: [Photo] = []
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.searchBarStyle = .prominent
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "검색어를 입력해주세요."
        search.autocapitalizationType = .none
        return search
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImageListTableViewCell.self,
                           forCellReuseIdentifier: ImageListTableViewCell.cellID)
        
        return tableView
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        configureTableView()
        configureSearchBar()
        configureImageListDataSource()
        configureNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPhotos()
    }
    
    deinit {
        removeNotificationObserver()
    }
}

//MARK: - Configure Views And Layout
extension SearchViewController: HierarchySetupable {
    func setupViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDataSource
        tableView.rowHeight = view.frame.size.height / 4
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    private func configureImageListDataSource() {
        tableViewDataSource.delegate = self
    }
}

//MARK: - NetworkService
extension SearchViewController {
    private func reloadPhotos() {
        guard photos.isEmpty == false,
              TokenManager.shared.isTokenSaved else { return }
        photos = []
        page = 1
        searchPhotos()
    }
    
    private func searchPhotos() {
        networkService.searchPhotos(type: SearchPhoto.self,
                                    query: query,
                                    page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                photoResult.photos.forEach { self.photos.append($0) }
                self.tableViewDataSource.photos = self.photos
                self.tableView.reloadData()
                self.page += 1
                
            case .failure(let error):
                //MARK: Todo: 에러메시지 출력
                debugPrint("사진가져오기 실패", error.localizedDescription)
            }
        }
    }
    
    private func fetchLikePhoto(photoId: String) {
        guard let index = photos.firstIndex(where: { $0.id == photoId }) else { return }
        
        if photos[index].isUserLike {
            networkService.photoUnlike(id: photoId, completion: judgeLikeResult(_:))
        } else {
            networkService.photoLike(id: photoId, completion: judgeLikeResult(_:))
        }
    }
    
    private func judgeLikeResult(_ result: Result<PhotoLike, Error>) {
        switch result {
        case .success(let photoResult):
            photos.firstIndex { $0.id == photoResult.photo.id }
            .map { Int($0) }
            .flatMap {
                photos[$0].isUserLike = photoResult.photo.isUserLike
                photos[$0].likes = photoResult.photo.likes
            }
            self.tableViewDataSource.photos = self.photos
            self.tableView.reloadData()
            
        case .failure:
            print("좋아요를 실패하였습니다.")
        }
    }
}


//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.query = query
        self.photos = []
        self.page = 1
        searchPhotos()
        searchBar.resignFirstResponder()
    }
}

//MARK: - Image List DataSource Delegate
extension SearchViewController: ImageListDataSourceDelegate {
    func morePhotos() {
        searchPhotos()
    }
    
    func didTapedLikeButton(photoId: String) {
        guard TokenManager.shared.isTokenSaved else { return }
        fetchLikePhoto(photoId: photoId)
    }
}

//MARK: - Notification Add Observer
extension SearchViewController {
    private func configureNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceivedNotification(_:)),
                                               name: .didFinishedDeleteKeyChainValue, object: nil)
    }
    
    @objc func didReceivedNotification(_ sender: Notification) {
        tableViewDataSource.photos = []
        tableView.reloadData()
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .didFinishedDeleteKeyChainValue,
                                                  object: nil)
    }
}

//MARK: - TabBar Image Info Protocol
extension SearchViewController: TabBarImageInfo {
    var nomal: String {
        return "magnifyingglass.circle"
    }
    
    var selected: String {
        return "magnifyingglass.circle.fill"
    }
    
    var barTitle: String {
        return "Search"
    }
}

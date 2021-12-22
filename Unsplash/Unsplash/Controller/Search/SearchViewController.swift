//
//  ViewController.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Properties
    private var photos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let networkService = UnsplashAPIManager()
    private var page: Int = 1
    private var query: String = ""
    
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
        tableView.register(SearchTableViewCell.self,
                           forCellReuseIdentifier: SearchTableViewCell.cellID)
        
        return tableView
    }()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        configureTableView()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPhotos()
    }
}

//MARK: - Method
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = view.frame.size.height / 4
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }
    
    //MARK: Network Service
    private func searchPhotos(for page: Int, query: String) {
        networkService.searchPhotos(type: SearchPhoto.self,
                                    query: query,
                                    page: page) { [weak self] result in
            self?.page += 1
            
            switch result {
            case .success(let photoResult):
                photoResult.photos.forEach { self?.photos.append($0) }
            case .failure(let error):
                //MARK: Todo: 에러메시지 출력
                print(error.localizedDescription)
            }
        }
    }
    
    private func photoLike(photoId: String) {
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
            
        case .failure:
            print("에러발생")
        }
    }
    
    private func reloadPhotos() {
        guard photos.isEmpty == false,
              TokenManager.shared.isTokenSaved else { return }
        photos = []
        page = 1
        searchPhotos(for: page, query: query)
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellID,
                                                       for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]
        
        cell.delegate = self
        cell.configure(id: photo.id,
                       photographerName: photo.user?.username,
                       likeCount: String(photo.likes),
                       isUserLike: photo.isUserLike,
                       imageUrl: photo.urls.regularURL)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottomHeight = contentHeight - yOffset
        
        let frameHeight = scrollView.frame.size.height
        
        if heightRemainBottomHeight < frameHeight && photos.isEmpty == false  {
            searchPhotos(for: self.page, query: self.query)
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.query = query
        self.page = 1
        self.photos = []
        searchPhotos(for: self.page, query: query)
        searchBar.resignFirstResponder()
    }
}

//MARK: - Search TableView Cell Delegate(Like Button Tap)
extension SearchViewController: SearchTableViewCellDelegate {
    func didTapedLikeButton(_ id: String) {
        guard TokenManager.shared.isTokenSaved else { return }
        photoLike(photoId: id)
    }
}

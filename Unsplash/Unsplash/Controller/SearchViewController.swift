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
        
        cell.configure(id: photo.id,
                       title: photo.user?.username,
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

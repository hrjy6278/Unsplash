//
//  ImageListDataSource.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/22.
//

import Foundation
import UIKit

//MARK: Delegate
protocol ImageListDataSourceDelegate: AnyObject {
    func didFinishedFetchImage(isSuceesed: Bool)
}

final class ImageListDataSource: NSObject {
    //MARK: Properties
    weak var delegate: ImageListDataSourceDelegate?
    
    private let networkService = UnsplashAPIManager()
    private var page: Int = 1
    private var query: String = ""
    private var photos: [Photo] = []
}

//MARK: - NetworkService
extension ImageListDataSource {
    func reloadPhotos() {
        guard photos.isEmpty == false,
              TokenManager.shared.isTokenSaved else { return }
        photos = []
        page = 1
        searchPhotos(query: query)
    }
    
    func searchPhotos(query: String) {
        self.query = query
        
        networkService.searchPhotos(type: SearchPhoto.self,
                                    query: query,
                                    page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                photoResult.photos.forEach { self.photos.append($0) }
                
                self.page += 1
                self.delegate?.didFinishedFetchImage(isSuceesed: true)
                
            case .failure(let error):
                //MARK: Todo: 에러메시지 출력
                debugPrint("사진가져오기 실패", error.localizedDescription)
                self.delegate?.didFinishedFetchImage(isSuceesed: false)
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
            delegate?.didFinishedFetchImage(isSuceesed: true)
            
        case .failure:
            print("좋아요를 실패하였습니다.")
            delegate?.didFinishedFetchImage(isSuceesed: false)
        }
    }
}
//MARK: - UITableView DataSource
extension ImageListDataSource: UITableViewDataSource {
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

//MARK: - Search TableView Cell Delegate(Like Button Tap)
extension ImageListDataSource: SearchTableViewCellDelegate {
    func didTapedLikeButton(_ id: String) {
        guard TokenManager.shared.isTokenSaved else { return }
        fetchLikePhoto(photoId: id)
    }
}

//MARK: - UITableView Delegate
extension ImageListDataSource: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainBottomHeight = contentHeight - yOffset
        
        let frameHeight = scrollView.frame.size.height
        
        if heightRemainBottomHeight < frameHeight && photos.isEmpty == false  {
            searchPhotos(query: self.query)
        }
    }
}

//
//  NetworkService.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import Foundation
import Alamofire

final class UnsplashAPIManager {
    private var isFetching = false
    
    func searchPhotos<T: Decodable>(type: T.Type,
                                    query: String,
                                    page: Int,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
        guard isFetching == false else { return }
        
        self.isFetching = true
        AF.request(UnsplashRouter.searchPhotos(query: query, page: page))
            .responseData { responseData in
                
                self.isFetching = false
                switch responseData.result {
                case .success(let data):
                    do {
                        let decodedData = try PasingManager.decode(type: type, data: data)
                        completion(.success(decodedData))
                    } catch (let error) {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

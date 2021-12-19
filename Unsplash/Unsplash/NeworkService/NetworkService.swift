//
//  NetworkService.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import Foundation
import Alamofire

struct NetworkService {
    
    static func searchPhotos<T: Decodable>(type: T.Type,
                                           query: String,
                                           page: Int,
                                           completion: @escaping (Result<T, Error>) -> Void) {
        let queryParameter: [String: String] = [
            "client_id": "UUGSJm9EzJM5tw1ngfNkKSn_OGW26g-O-z5FgLJEPPk",
            "page": String(page),
            "query": query
        ]
        
        AF.request(EndPoint.searchPhotos.description, method: .get, parameters: queryParameter, encoder: .urlEncodedForm).responseData { responseData in
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

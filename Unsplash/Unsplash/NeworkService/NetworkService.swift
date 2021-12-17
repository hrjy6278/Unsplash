//
//  NetworkService.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import Foundation
import Alamofire

struct NetworkService {
    
    static func FindPhotoData<T: Decodable>(_ url: URL,
                                            type: T.Type,
                                            queryItem: [String : String],
                                            completion: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(url, method: .get, parameters: queryItem, encoder: .urlEncodedForm).responseData { responseData in
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

//
//  UnsplashInterceptor.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/20.
//

import Foundation
import Alamofire

final class UnsplashInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        //MARK: Todo 키체인을 활용하여 token 넣어주기
        
        completion(.success(urlRequest))
    }
}

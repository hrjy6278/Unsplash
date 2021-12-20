//
//  UnsplashRouter.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/20.
//

import Foundation
import Alamofire

enum UnsplashRouter {
    case searchPhotos(query: String, page: Int)
    case userAuthorize
    case fetchAccessToken(accessCode: String)
    
    var baseURL: String {
        switch self {
        case .searchPhotos:
            return "https://api.unsplash.com"
        case .fetchAccessToken, .userAuthorize:
            return "https://unsplash.com"
        }
    }
    
    var path: String {
        switch self {
        case .searchPhotos:
            return "/search/photos"
        case .fetchAccessToken, .userAuthorize:
            return "/oauth/authorize"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchPhotos, .userAuthorize:
            return .get
        case .fetchAccessToken:
            return .post
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .searchPhotos(let query, let page):
            return [
                "client_id": UnsplashParameter.clientID,
                "page": String(page),
                "query": query
            ]
        case .userAuthorize:
            return [
                "client_id": UnsplashParameter.clientID,
                "redirect_uri": UnsplashParameter.redirectURL,
                "response_type": UnsplashParameter.responseType,
                "scope": UnsplashParameter.scope.map { $0.rawValue }.joined(separator: "+")
            ]
        case .fetchAccessToken(let code):
            return [
                "client_id": UnsplashParameter.clientID,
                "client_secret": UnsplashParameter.clientSecret,
                "redirect_uri": UnsplashParameter.redirectURL,
                "code": code,
                "grant_type": UnsplashParameter.grandType
            ]
        }
    }
}

//MARK: - Method
extension UnsplashRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        switch method {
        case .get:
            request = try URLEncodedFormParameterEncoder().encode(parameters,
                                                                  into: request)
        case .post:
            request = try JSONParameterEncoder().encode(parameters,
                                                        into: request)
        default:
            break
        }
        
        return request
    }
}

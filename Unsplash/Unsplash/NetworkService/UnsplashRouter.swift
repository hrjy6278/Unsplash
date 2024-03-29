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
    case photoLike(id: String)
    case photoUnlike(id: String)
    case myProfile
    case listUserLike(userName: String, page: Int)
    
    var baseURL: String {
        switch self {
        case .searchPhotos, .photoLike, .photoUnlike, .myProfile, .listUserLike:
            return "https://api.unsplash.com"
        case .fetchAccessToken, .userAuthorize:
            return "https://unsplash.com"
        }
    }
    
    var path: String {
        switch self {
        case .searchPhotos:
            return "/search/photos"
        case .photoLike (let id), .photoUnlike(let id):
            return "/photos/\(id)/like"
        case .listUserLike(let userName, _):
            return "/users/\(userName)/likes"
        case .myProfile:
            return "/me"
        case .userAuthorize:
            return "/oauth/authorize"
        case .fetchAccessToken:
            return "/oauth/token"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchPhotos, .userAuthorize, .myProfile, .listUserLike:
            return .get
        case .fetchAccessToken, .photoLike:
            return .post
        case .photoUnlike:
            return .delete
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .searchPhotos(let query, let page):
            return [
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
        case .listUserLike(_, let page):
            return ["page": String(page)]
        case .photoLike, .photoUnlike, .myProfile:
            return [:]
        }
    }
}

//MARK: - Method
extension UnsplashRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .searchPhotos, .userAuthorize, .photoLike, .photoUnlike, .myProfile, .listUserLike:
            let url = request.url?.appendingQueryParameters(parameters)
            request.url = url
        case .fetchAccessToken:
            request = try JSONParameterEncoder().encode(parameters,
                                                        into: request)
        }
        
        return request
    }
}

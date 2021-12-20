//
//  EndPoint.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/17.
//

import Foundation

enum EndPoint: CustomStringConvertible {
    private static var BaseURL = "https://api.unsplash.com/"
    
    case searchPhotos
    
    var description: String {
        switch self {
        case .searchPhotos:
            return Self.BaseURL + "search/photos"
        }
    }
}

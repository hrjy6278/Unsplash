//
//  SearchPhoto.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/18.
//

import Foundation

struct SeachPhoto: Codable {
    let total: Int
    let totalPages: Int
    let Photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case Photos = "results"
        case totalPages = "total_pages"
    }
    
    struct Photo: Codable {
        let id: String
        let createdAt: Date
        let description: String
        let urls: Urls
        let links: PhotoLink
        
        enum CodingKeys: String, CodingKey {
            case id, description, urls, links
            case createdAt = "created_at"
        }
    }
    
    struct PhotoLink: Codable {
        let linksSelf, html, download : String
        
        enum CodingKeys: String, CodingKey {
            case html, download
            case linksSelf = "self"
        }
    }
    
    struct Urls: Codable {
        let raw, full, regular, small, thumb: String
    }
    
    struct ProfileImage: Codable {
        let small, medium, large: String
    }
}



//
//  SearchPhoto.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/18.
//

import Foundation
import SwiftUI

struct SeachPhoto: Codable {
    let total: Int
    let totalPages: Int
    let Photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case Photos = "results"
        case totalPages = "total_pages"
    }
}

struct Photo: Codable {
    let id: String
    let createdAt: String
    let description: String?
    let user: User?
    let likes: Int
    let urls: Urls
    let links: PhotoLink
    
    enum CodingKeys: String, CodingKey {
        case id, description, urls, links, user, likes
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
    
    var regularURL: URL? {
        URL(string: regular)
    }
}

struct ProfileImage: Codable {
    let small, medium, large: String
}

struct User: Codable {
    let id: String
    let username: String?
}

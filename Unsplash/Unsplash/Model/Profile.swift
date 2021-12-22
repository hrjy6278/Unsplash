//
//  Profile.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/22.
//

import Foundation

struct Profile: Decodable {
    let id: String
    let username: String?
    let name: String?
    let profileImage: SelfieImage?
    
    enum CodingKeys: String, CodingKey {
        case id,username,name
        case profileImage = "profile_image"
    }
}

struct SelfieImage: Codable {
    let small, medium, large: String
    
    var mediumURL: URL? {
        URL(string: medium)
    }
}

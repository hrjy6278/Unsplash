//
//  TokenManager.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/20.
//

import Foundation

final class TokenManager {
    
    enum TokenManagerError: Error {
        case saveError(message: String)
    }
    //MARK: Properties
    private let userAccount = "accessToken"
    private let keyChaineStore = KeyChainStore()
    
    static let shared = TokenManager()
    
    //MARK: init
    private init() { }
}

//MARK: - Method
extension TokenManager {
    func saveAccessToken(unsplashToken: UnsplashAccessToken) throws {
        do {
            try keyChaineStore.setValue(unsplashToken.accessToken, for: userAccount)
        } catch let error {
           throw TokenManagerError.saveError(message: error.localizedDescription)
        }
    }
}

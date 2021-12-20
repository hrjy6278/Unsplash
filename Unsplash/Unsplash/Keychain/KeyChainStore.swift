//
//  KeyChainStore.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/20.
//

import Foundation
import Security

struct KeyChainStore {
    
    enum KeyChainError: Error {
        case stringToDataConversionError
        case error(description: OSStatus)
    }
    
    private var query: [String: Any] = [
        String(kSecClass): kSecClassGenericPassword,
        String(kSecAttrService): "UnsplashService"
    ]
    
    func setValue(_ value: String, for userAccount: String) throws {
        guard let encodedPassword = value.data(using: .utf8) else {
            throw KeyChainError.stringToDataConversionError
        }
        
        var query = self.query
        
        query[String(kSecAttrAccount)] = userAccount
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            var attributesToUpdate = [String: Any]()
            attributesToUpdate[String(kSecValueData)] = encodedPassword
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword
            status = SecItemAdd(query as CFDictionary, nil)
        default:
            throw KeyChainError.error(description: status)
        }
    }
}

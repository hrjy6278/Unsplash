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
        case error(message: String)
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
            throw error(status: status)
        }
    }
    
    func getValue(for userAccount: String) throws -> String? {
        var query = query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        case errSecSuccess:
            guard let queriedItem = queryResult as? [String: Any],
                  let passwordData = queriedItem[String(kSecValueData)] as? Data,
                  let password = String(data: passwordData, encoding: .utf8) else {
                      return nil
                  }
            return password
        case errSecItemNotFound:
            throw error(status: status)
        default:
            return nil
        }
    }
    
    func removeValue(for userAccount: String) {
        var query = query
        query[String(kSecAttrAccount)] = userAccount
        
        removeAll(query: query)
    }
    
    func removeAll(query: [String: Any]) {
        let query = query
        
        SecItemDelete(query as CFDictionary)
    }
    
    private func error(status: OSStatus) -> KeyChainError {
        let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? ""
        
        return KeyChainError.error(message: errorMessage)
    }
}

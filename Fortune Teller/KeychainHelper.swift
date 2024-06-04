//
//  KeychainHelper.swift
//  Fortune Teller
//
//  Created by E Martin on 5/28/24.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    func save(key: String, value: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            SecItemDelete(query as CFDictionary) // Delete any existing item
            SecItemAdd(query as CFDictionary, nil) // Add new item
        }
    }

    func get(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }
}

//
//  KeyChain.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-12-02.
//

import Security
import UIKit

class KeyChain {
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String : Any]
        
        var dataTypeRef: AnyObject? = nil
        
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }
    
    class func logout()  {
        let secItemClasses =  [
          kSecClassGenericPassword,
          kSecClassInternetPassword,
          kSecClassCertificate,
          kSecClassKey,
          kSecClassIdentity,
        ]
        for itemClass in secItemClasses {
          let spec: NSDictionary = [kSecClass: itemClass]
          SecItemDelete(spec)
        }
    }
}


//
//  Authentication.swift
//  Runner
//
//  Created by Bách Lê on 12/29/20.
//

//import Foundation
//import KeychainSwift
//
//class KeychainUtils {
//
//    static let shared = KeychainUtils()
//
//    let accessGroup = "2CK53JV6DM.com.fsi.doceyeKeychainGroup"
//
//    // Xử lý lưu username và password vào keychain
//    func saveUser(userId: String, name: String, password: String) {
//        let keychain = KeychainSwift()
//        keychain.accessGroup = accessGroup
//        keychain.set(userId, forKey: "userID")
//        keychain.set(name, forKey: "username")
//        keychain.set(password, forKey: "password")
//    }
//
//    func saveIsLogout() {
//        let keychain = KeychainSwift()
//        keychain.accessGroup = accessGroup
//        keychain.set("", forKey: "userID")
//        keychain.set("", forKey: "username")
//        keychain.set("", forKey: "password")
//        keychain.set("", forKey: "module")
//    }
//
//    func getUserID() -> String? {
//        let keychain = KeychainSwift()
//        keychain.accessGroup = accessGroup
//        if let userID = keychain.get("userID") {
//            print("userID = \(userID)")
//            return userID
//        } else {
//            return nil
//        }
//    }
//
//    func getUsername() -> String? {
//        let keychain = KeychainSwift()
//        keychain.accessGroup = accessGroup
//        if let userName = keychain.get("username") {
//            print("userName = \(userName)")
//            return userName
//        } else {
//            return nil
//        }
//    }
//
//    func getPassword() -> String? {
//        let keychain = KeychainSwift()
//        keychain.accessGroup = accessGroup
//        if let password = keychain.get("password") {
//            print("password = \(password)")
//            return password
//        } else {
//            return nil
//        }
//    }
//
//    func saveModule(module: String) {
//        let keychain = KeychainSwift()
//        keychain.accessGroup = accessGroup
//        keychain.set(module, forKey: "module")
//    }
//
//    func getModule() -> String? {
//        let keychain = KeychainSwift()
//        keychain.accessGroup = accessGroup
//        if let module = keychain.get("module") {
//            print("module = \(module)")
//            return module
//        } else {
//            return nil
//        }
//    }
//
//}

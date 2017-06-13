//
//  Userinfo.swift
//  PAYD
//
//  Created by Jennifer Buur on 13-06-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import Foundation

class Userinfo {
    
    static let shared = Userinfo()
    
    static var email = String()
    static var groups = [String]()
    
    func getEmail() -> String {
        return Userinfo.email
    }
    
    func getGroups() -> [String] {
        return Userinfo.groups
    }
}

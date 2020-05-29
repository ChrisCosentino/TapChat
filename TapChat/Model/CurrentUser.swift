//
//  User.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-23.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import Foundation

struct CurrentUser{
    let username: String
    let email: String
    let uid: String
    let provider: String
    
    init(data: [String: Any]) {
        self.email = data["email"] as! String
        self.uid = data["uid"] as! String
        self.username = data["username"] as! String
        self.provider = data["provider"] as! String
    }
    
    init(username: String, email: String, uid: String, provider: String) {
        self.username = username
        self.email = email
        self.uid = uid
        self.provider = "email"
    }
}

//
//  Friend.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-06-24.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import Foundation

struct Friend: Codable {
    let uid: String
    let username: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as! String
        self.username = data["username"] as! String
    }
}

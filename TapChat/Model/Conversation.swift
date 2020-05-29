//
//  Conversation.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-06-25.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import Foundation

struct Conversation: Codable{
    let messageId: String
    let friend: String
    //For later, add last message
    
    init(data: [String: Any]) {
        self.messageId = data["messageID"] as! String
        self.friend = data["friend"] as! String
    }
}

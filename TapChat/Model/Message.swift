//
//  Conversation.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-06-25.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import Foundation
import Firebase

struct Message {
  
    let message: String
    let sender: String
    //let time: Timestamp
    let time: Timestamp
    
    //With this release the behavior for Date objects stored in Firestore changed: "timestamps stored in Cloud Firestore are read back as Firebase Timestamp objects instead of as system Date objects."
    
    //You need to "update your code expecting a Date to instead expect a Timestamp", as follows:
    

    init(data: [String: Any]){
        self.message = data["message"] as! String
        self.sender = data["sender"] as! String
       
       self.time = data["time"] as! Timestamp
        
    }
    init(message: String, sender: String, time: Timestamp){
        self.message = message
        self.sender = sender
       // self.time = time
        self.time = time
    }
}



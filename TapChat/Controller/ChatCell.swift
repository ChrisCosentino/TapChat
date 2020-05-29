//
//  ChatCell.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-07-16.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var messageLbl: UITextView!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

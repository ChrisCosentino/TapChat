//
//  MessageListCell.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-23.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit

class MessageListCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var preview: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MaterialTextView.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-08-16.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit

class MaterialTextView: UITextView {

    override func awakeFromNib() {
        layer.cornerRadius = 20.0
        self.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

}

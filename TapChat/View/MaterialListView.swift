//
//  MaterialView.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-23.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit

class MaterialListView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 15.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 6
        
    }

}

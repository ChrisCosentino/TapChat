//
//  MaterialFormTextField.swift
//  ExHiBit
//
//  Created by Chris Cosentino on 2019-05-22.
//  Copyright © 2019 Chris Cosentino. All rights reserved.
//

import UIKit

class MaterialFormTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        
        //Adds indentation to begining of textfield
        let leftPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 2.0))
        leftView = leftPadding
        leftViewMode = .always
    }

}

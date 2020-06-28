//
//  popup.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 06/08/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class Popup:UIView {
    var textField: UITextField
    var OKButton: UIButton
    
    init(frame: CGRect, text:String) {
        self.textField = UITextField(frame: CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.height - 10))
        self.OKButton = UIButton(frame: CGRect(x: frame.width - 10 - 46, y: frame.height - 10 - 30, width: 46, height: 30))
        textField.text = text
        OKButton.setTitle("OK", for: UIControlState())
        OKButton.setTitleColor(UIColor.blue, for: UIControlState())
        super.init(frame: frame)
        self.addSubview(textField)
        self.addSubview(OKButton)
        self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.textField.layer.cornerRadius = 10.0
        self.textField.clipsToBounds = true
        textField.backgroundColor = UIColor.white
        OKButton.addTarget(self, action: #selector(Popup.OK), for: UIControlEvents.touchUpInside)
        textField.isUserInteractionEnabled = false 
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func OK() {
        self.isHidden = true
    }
}

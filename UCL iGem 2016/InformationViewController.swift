//
//  informationPageViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 17/08/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var image:UIImage?
    var text:String?

    override func viewDidLoad() {
        self.imageView.image = image
        self.textView.text = text
        
    }
}

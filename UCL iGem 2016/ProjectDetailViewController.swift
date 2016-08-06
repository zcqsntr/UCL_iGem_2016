//
//  ProjectDetailViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 01/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {
    @IBOutlet weak var text: UITextView!
    var whichRow:Int?
    let text1 = "Oxidative stress – the root of the problem: Oxidative stress underlies many of the health problems of ageing so we will develop a number of free radical mopping devices. These devices will include therapeutic bacterial chassis triggered by oxidative-stress to deliver free-radical mopping compounds."
    let text2 = "False teeth – a thing of the past: Increasing tooth loss remains a feature of old age in humans throughout the world. We will harness synthetic biology to improve the dental health of the ageing population by designing bacteria that do not cause decay but actually prevent it. These biofilm-fillings will provide a regenerative internal environment for the tooth whilst fighting off the surface bacteria that cause dental plaques."
    let text3 = "Grey love – it does not have to be dangerous: You may be surprised to know that sexually transmitted diseases are particularly prevalent in elderly populations. By embedding living biosensors into lubricant gels we will simplify the process of screening potential partners for sexually transmitted infections – as the gel will glow in the night on contact with organisms such as Neisseria gonorrhoeae."
    
    override func viewDidLoad() {
        let textArray = [text1, text2, text3]
        text.text = textArray[whichRow!]
    }
    
}

//
//  bioBrickView.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 01/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class bioBrickView: UIImageView {
    
    
    /*func restrict(bioBrick:[DNAFragment], restrictionEnzymes:[String]) {
        for fragment in bioBrick {
            if restrictionEnzymes.contains(fragment.leftRS!) {
                fragment.leftIsCut = true
            }
            if restrictionEnzymes.contains(fragment.rightRS!) {
                fragment.rightIsCut = true
            }
        }
    }*/
    
    
    
    
    /*func displayPlasmid(bioBrick :[DNAFragment]) {
        /// have the backgrund plasmid
        // on top of plasmid go trough biobrick and display fragments colorcoded depending on the RS and the type (promoter, reporter, gene etc)
        var i = 0
        for fragment in bioBrick {
            switch (fragment.leftRS!, fragment.rightRS!) {
                case ("XBa1", "Spe1"):
                    fragment.image = UIImage(named: "XjunkS")
                case ("Pst1", "EcoR1"):
                    fragment.image = UIImage(named: "PjunkE")
            default: break
            }
            i += 1
            fragment.userInteractionEnabled = true
            fragment.frame.size = CGSize(width: 91, height: 14)
            fragment.center = CGPoint(x: 169 + CGFloat(60*i), y: 245)
            addSubview(fragment)
        }}*/
        
    

}

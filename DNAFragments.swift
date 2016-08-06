//
//  DNAFragment.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 01/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

//MARK: Protocols
protocol DNAFragmentDelegate {
    func fragmentDropped(doubleFragment:DoubleFragmentContainer)
}

//MARK: Double Fragment Container
class DoubleFragmentContainer: UIView {
    var leftFragment:DNAFragment
    var rightFragment:DNAFragment
    let otherRSLeft = UIImageView(image: UIImage(named: "otherRSLeft"))
    let otherRSRight = UIImageView(image: UIImage(named: "otherRSRight"))
    
    init(frame: CGRect, leftFragment:DNAFragment, rightFragment:DNAFragment, overhang:CGFloat) {
        leftFragment.frame.origin = CGPointMake(0, 0)
        rightFragment.frame.origin = CGPointMake(leftFragment.frame.size.width - overhang*2, 0)
        self.leftFragment = leftFragment
        self.rightFragment = rightFragment
        super.init(frame: frame)
        self.addSubview(leftFragment)
        self.addSubview(rightFragment)
        if leftFragment is RestrictionSites {
            self.bringSubviewToFront(leftFragment)
        } else if rightFragment is RestrictionSites {
            self.bringSubviewToFront(rightFragment)
        }
        
        if leftFragment is RestrictionSites {
            otherRSRight.frame = CGRectMake(self.frame.width - 20, 0, 20, leftFragment.frame.height)
            self.addSubview(otherRSRight)
        } else if rightFragment is RestrictionSites {
            otherRSLeft.frame = CGRectMake(0, 0, 20, leftFragment.frame.height)
            self.addSubview(otherRSLeft)
        }
        //self.backgroundColor = UIColor(red: 0, green: 0, blue: 255, alpha: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: DNAFragmentDelegate?
    var hasBeenTouched = false
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch!
        self.center = touch.locationInView(self.superview)
        hasBeenTouched = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch!
        self.center = touch.locationInView(self.superview)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.fragmentDropped(self)
    }
    
}

//MARK: Fragment Types
class DNAFragment: UIImageView {
    var name:String?
    override var description: String {
        return self.name!
    }
    
    //sort out initialisers
    init(name:String, image: UIImage, width:CGFloat, height:CGFloat) {
        super.init(image: image)
        self.name = name
        self.frame.size = CGSize(width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SmallFragment: DNAFragment {
    
}

class RestrictionSites: SmallFragment {
    var isCut = false
    var side:String
    var originalImage:UIImage
    var smallWidth: CGFloat
    var largeWidth: CGFloat
    
    init(name: String, image: UIImage, smallWidth: CGFloat,largeWidth:CGFloat, height: CGFloat, side:String) {
        self.side = side
        self.originalImage = image
        self.smallWidth = smallWidth
        self.largeWidth = largeWidth
        super.init(name: name, image: image, width: smallWidth, height: height)
    }
    
    func reloadImage() {
        if isCut {
            self.frame.size.width = largeWidth
            switch self.side {
            case "left":
                self.image = UIImage(named:"leftSpaceWithRSs.png")
            case "right":
                self.image = UIImage(named: "rightSpaceWithRSs.png")
            default: break
                
            }
            //self.backgroundColor = UIColor.grayColor()
        } else {
            self.frame.size.width = smallWidth
            self.image = originalImage
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class Promoter:DNAFragment {
    var activator: String?
    var threshold:Int
    
    init(name:String, image:UIImage, width:CGFloat, height:CGFloat, activator:String, threshold: Int){
        self.activator = activator
        self.threshold = threshold
        super.init(name: name, image: image, width:width, height:height)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Repressor:DNAFragment {
    var repressor:String?
    var isRepressed:Bool?

}

class Producer: DNAFragment {
    var substance:String?
    
    init(name: String, image: UIImage, width: CGFloat, height: CGFloat, substance:String) {
        super.init(name: name, image: image, width: width, height: height)
        self.substance = substance
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate(petrieDish:PetrieDish) {
        print("active")
        let substance = UIImageView()
        switch self.substance! {
        case "insulin":
            break
            //image = insulin
            //let substance = UIImageView(image: UIImage(named: "))
        case "bacteriocin":
            
            //image = toxin
            substance.image =  UIImage(named: "bacteriocin")
            substance.frame.size = CGSize(width: 20, height: 20)
            petrieDish.bacteriocins.append(substance)
        default:
            break
        }
        for bacteria in petrieDish.goodBacterias {
            if drand48() < 0.05 {
                substance.center = bacteria.center
                petrieDish.addSubview(substance)
            }
        }
    }
    
}

class Reporter:DNAFragment {
    var colour: String?
    
    init(name:String, image:UIImage, width:CGFloat, height:CGFloat, colour:String){
        super.init(name:name,image: image, width: width, height: height)
        self.colour = colour
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activate(petrieDish:PetrieDish) {
        for bacteria in petrieDish.goodBacterias {
            if drand48() < 0.2 {
                switch colour! {
                    case "Green": bacteria.image = UIImage(named: "GFP Bacteria.png")
                    case "Red": bacteria.image = UIImage(named: "RFP Bacteria.png")
                    case "Blue": bacteria.image = UIImage(named: "BFP Bacteria.png")
                    default: break
                }
            }
        }
    }
    
}


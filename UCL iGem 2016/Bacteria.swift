//
//  Bacteria.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 04/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit


protocol BacteriaDelegate {
    func bacteriaBropped(bacteria:Bacteria)
}

class Bacteria:UIImageView  {
    var direction = CGPoint(x: 0,y: 0)
    var canReplicate = true

    var delegate:BacteriaDelegate?
    var type:String?
    
    override var description: String {
        return self.type!
    }
    func move() {
        self.center.x = self.center.x + CGFloat((drand48()-0.5))+self.direction.x
        self.center.y = self.center.y + CGFloat((drand48()-0.5))+self.direction.y
        
    }
    
    func rotate() {
        
    }
    
    func checkDistance() {
        let petrieDish = self.superview as! PetrieDish
        let center = CGPoint(x: (petrieDish.frame.width)/2, y: (petrieDish.frame.height)/2)
        let position = (self.center)
        let deltaX = Float(abs(center.x-position.x))
        let deltaY = Float(abs(center.y-position.y))
        let distance = sqrt(powf(deltaX,2)+powf(deltaY,2))
        let radius = Float(petrieDish.frame.height)/2
        
        if distance >= radius - 15 {
            self.direction.x = -self.direction.x
            self.direction.y = -self.direction.y
            
        } else if drand48() <= 0.002{ //randomly change direction sometimes
            self.direction.x = CGFloat(drand48())
            self.direction.y = CGFloat(drand48())
        }
    
    }
    
    func replicate(){
        let bacteria = Bacteria()
        bacteria.direction.x = CGFloat((drand48()-0.5))
        bacteria.direction.y = CGFloat((drand48()-0.5))
        bacteria.frame.size = self.frame.size
        bacteria.center = self.center
        bacteria.image = self.image
        bacteria.type = self.type
        //want to use delegates for this
        self.superview?.addSubview(bacteria)
        let petrieDish = superview as! PetrieDish
        if bacteria.type == "good" {
            petrieDish.goodBacterias.append(bacteria)
        } else {
            petrieDish.badBacterias.append(bacteria)
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch!
        self.center = touch.locationInView(self.superview)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch!
        self.center = touch.locationInView(self.superview)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.delegate?.bacteriaBropped(self)
    }

}
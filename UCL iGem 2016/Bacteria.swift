//
//  Bacteria.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 04/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

protocol BacteriaDelegate {
    func bacteriaBropped(_ bacteria:Bacteria)
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
        let center = CGPoint(x: (571)/2, y: (571)/2)
        let position = (self.center)
        let deltaX = Float(center.x-position.x) + Float(drand48())
        let deltaY = Float(center.y-position.y) + Float(drand48())
        let distance = sqrt(powf(abs(deltaX),2)+powf(abs(deltaY),2))
        let radius = Float(571)/2
        
        if distance >= radius - 15 {
            self.direction.x = CGFloat(deltaX / sqrt(pow(deltaX, 2) + pow(deltaY,2)))
            self.direction.y = CGFloat(deltaY / sqrt(pow(deltaX, 2) + pow(deltaY,2)))
            self.center.x += self.direction.x * 4
            self.center.y += self.direction.y * 4
        } else if drand48() <= 0.002{ //randomly change direction sometimes
            self.direction.x = CGFloat(drand48())
            self.direction.y = CGFloat(drand48())
        }
    }
    func replicate() {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch!
        self.center = touch.location(in: self.superview)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch! = touches.first as UITouch!
        self.center = touch.location(in: self.superview)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.bacteriaBropped(self)
    }
}

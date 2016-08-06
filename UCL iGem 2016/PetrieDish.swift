//
//  PetrieDish.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 05/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit


class PetrieDish: UIImageView {
    var goodBacterias:[Bacteria] = []
    var badBacterias:[Bacteria] = []
    var bioBrick:[DNAFragment]?
    var PH:Int?
    var temperature:Int?
    var lightIsOn:Bool?
    let replicationProb = 0.1
    var bacteriocins:[UIImageView] = []
    
    func addBacteria(newBacteria:Bacteria) {
        self.addSubview(newBacteria)
        if newBacteria.type == "good" {
            goodBacterias.append(newBacteria)
        } else {
            badBacterias.append(newBacteria)
        }
    }
    
    func move() {
        for bacteria in goodBacterias {
            bacteria.checkDistance()
            bacteria.move()
        }
        for bacteria in badBacterias {
            bacteria.checkDistance()
            bacteria.move()
        }
    }
    
    func replicate() {
        if self.goodBacterias.count+self.badBacterias.count <= 100 {
            for bacteria in self.goodBacterias {
                if drand48() < replicationProb {
                    bacteria.replicate()
                }
            }
            for bacteria in self.badBacterias {
                if drand48() < replicationProb {
                    bacteria.replicate()
                }
            }
        }
        
    }
    
    func startMovement() {
        let moveTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("move"), userInfo: nil, repeats: true)
        let replicationTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("replicate"), userInfo: nil, repeats: true)
    }
    
    //find out which genes are active depending on conditions
//    func getActiveGenes() {
//        let currentConditions = [("PH",self.PH), ("Temperature",self.temperature)]
//        var underActivepromoter = false
//        for fragment in bioBrick! {
//            if let promoter = fragment as! Promoter {
//                underActivepromoter = promoter.checkActive(self,currentConditions)
//            } else if underActivepromoter {
//                //express gene
//            }
//}
    
 //   }
}

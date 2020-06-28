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
    var sugarConc:Int?
    var lightIsOn:Bool?
    let replicationProb = 0.1
    var bacteriocins:[UIImageView] = []
    var insulins:[UIImageView] = []

    func addBacteria(_ newBacteria:Bacteria) {
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
        let moveTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PetrieDish.move), userInfo: nil, repeats: true)
        let replicationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PetrieDish.replicate), userInfo: nil, repeats: true)
    }
}

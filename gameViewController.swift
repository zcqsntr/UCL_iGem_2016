//
//  gameViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 01/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class gameViewController: UIViewController, UICollisionBehaviorDelegate, BacteriaDelegate {
    
    var activeGenes:[DNAFragment]?
    var bioBrick:[DNAFragment]? //passed from the editPlasmidViewController
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var petrieDish: PetrieDish!
    @IBOutlet weak var conditionsBubble: UIImageView!
    @IBOutlet weak var conditionsView: UIView!
    @IBOutlet weak var lightView: UIImageView!
    @IBOutlet weak var badBacteria: Bacteria!
    @IBOutlet weak var goodBacteria: Bacteria!
    @IBOutlet weak var bacteriaView: UIView!
    var collision:UICollisionBehavior!
    var animator:UIDynamicAnimator!
    
    @IBAction func panelSwitch(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            conditionsView.isHidden = false
            bacteriaView.isHidden = true
            conditionsBubble.image = UIImage(named:"promoterBubble")
            break
        case 1:
            bacteriaView.isHidden = false
            conditionsView.isHidden = true
            conditionsBubble.image = UIImage(named:"genesBubble")
        case 2:
            //conditionsView.hidden = true
            //show lightView
            lightView.isHidden = !lightView.isHidden
            petrieDish.lightIsOn = !petrieDish.lightIsOn!
        default: break
        }
    }
    //function attached to conditions buttons
    @IBAction func conditionChange(_ sender: UIButton) {
        switch sender.tag {
            case 0: if petrieDish.PH > 1 {petrieDish.PH! -= 1}
            case 1: if petrieDish.PH < 9 {petrieDish.PH! += 1}
            case 2:if petrieDish.temperature > 1 {petrieDish.temperature! -= 1}
            case 3: if petrieDish.temperature < 9 {petrieDish.temperature! += 1}
            case 4:if petrieDish.sugarConc > 1 {petrieDish.sugarConc! -= 1}
            case 5: if petrieDish.sugarConc < 9 {petrieDish.sugarConc! += 1}
            default: break
        }
        loadConditions()
    }
    //get biobrick from palsmid editor
    @IBAction func unwindToGameView(_ sender:UIStoryboardSegue){
        let previousVC = sender.source as! editPlasmidViewController
        self.bioBrick = previousVC.bioBrick
        let activateTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(gameViewController.getActiveGenes), userInfo: nil, repeats: true)
        let bacteriocinTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(gameViewController.poisonBadBacteria), userInfo: nil, repeats: true)
    }
    override func viewDidLoad() {
        petrieDish.PH = 4
        petrieDish.temperature = 4
        petrieDish.sugarConc = 4
        petrieDish.lightIsOn = false
        loadConditions()
        
        if bioBrick == nil {
            bioBrick = []
        }
        goodBacteria.type = "good"
        badBacteria.type = "bad"
        goodBacteria.isUserInteractionEnabled = true
        badBacteria.isUserInteractionEnabled = true
        goodBacteria.delegate = self
        badBacteria.delegate = self
        let moveAndReplicateTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(gameViewController.moveAndReplicate), userInfo: nil, repeats: true)
        let panelPopup = Popup(frame: CGRect(x: conditionsView.center.x - 250, y: conditionsView.center.y - 125, width: 500, height: 250), text: "This is the panel....")
        let petrieDishPopup = Popup(frame: CGRect(x: petrieDish.center.x - 150, y: petrieDish.center.y - 150, width: 300, height: 300), text: " this is the petrieDish...")
        self.view.addSubview(panelPopup)
        self.view.addSubview(petrieDishPopup)
        
    }
    func bacteriaBropped(_ bacteria: Bacteria) {
        let newBacteria = Bacteria()
        let pointInSuperview = self.view.convert(bacteria.center, from: bacteria.superview)
        let pointInPetrieDish = self.petrieDish.convert(pointInSuperview, from: self.view)
        
        newBacteria.direction.x = CGFloat((drand48()-0.5))
        newBacteria.direction.y = CGFloat((drand48()-0.5))
        newBacteria.frame.size = bacteria.frame.size
        newBacteria.center = pointInPetrieDish
        newBacteria.image = bacteria.image
        newBacteria.type = bacteria.type
        if bacteria.type == "good" {
            petrieDish.goodBacterias.append(newBacteria)
        } else {
            petrieDish.badBacterias.append(newBacteria)
        }
        bacteria.removeFromSuperview()
        petrieDish.addSubview(newBacteria)
        petrieDish.startMovement()
    }
    func getActiveGenes() {
        //let currentConditions = ["Temperature":petrieDish.temperature!,"PH":petrieDish.PH!]
        var currentlyActive = false
        activeGenes = []
        
        for fragment in bioBrick! {
            if fragment is Promoter {
                let fragment = fragment as! Promoter
                switch fragment.activator! {
                    case "Temperature":
                        if petrieDish.temperature == fragment.threshold {
                            currentlyActive = true
                        }
                    case "PH":
                        if petrieDish.PH == fragment.threshold {
                            currentlyActive = true
                        }
                    case "GreenLight":
                        if petrieDish.lightIsOn! {
                            currentlyActive = true
                        }
                    case "Sugar":
                        if petrieDish.sugarConc == fragment.threshold {
                            currentlyActive = true
                        }
                default: break
                }
            } else if (fragment is Producer || fragment is Reporter) && currentlyActive {
                activeGenes!.append(fragment)
                
            } else if fragment is Repressor {
                currentlyActive = false
            }
        }
        activateGenes(activeGenes!)
    }
    func activateGenes(_ activeGenes:[DNAFragment]) {
        if activeGenes.count == 0 {
            resetBacteriaColour()
        } else {
            for fragment in activeGenes {
                switch fragment {
                case fragment as Reporter: (fragment as! Reporter).activate(self.petrieDish)
                case fragment as Producer: (fragment as! Producer).activate(self.petrieDish)
                //do for other classes of Fragment
                default: break
                }
            }
        }
    }
    func resetBacteriaColour() {
        for bacteria in petrieDish.goodBacterias  {
            if drand48() < 0.2 {
                bacteria.image = UIImage(named:"greenBacteria.png")
            }
        }
    }
    //create conditions bubble and buttons
    func loadConditions() {
        for i in 0...3 {
            for j in 0...8 {
                let bubble = UIImageView(frame: CGRect(x: CGFloat(j*34), y: 3 + CGFloat(i*46), width: CGFloat(27), height: CGFloat(27)))
                switch i {
                case 0: if j <= petrieDish.PH! - 1 {
                    bubble.image = UIImage(named: "conditionsButtonFull")
                } else {
                    bubble.image = UIImage(named: "conditionsButtonEmpty")
                    }
                case 1: if j <= petrieDish.temperature! - 1{
                    bubble.image = UIImage(named: "conditionsButtonFull")
                } else {
                    bubble.image = UIImage(named: "conditionsButtonEmpty")
                    }
                case 2: if j <= petrieDish.sugarConc! - 1{
                    bubble.image = UIImage(named: "conditionsButtonFull")
                } else {
                    bubble.image = UIImage(named: "conditionsButtonEmpty")
                }
                case 3:
                    break
                    if j <= petrieDish.temperature! - 1{
                    bubble.image = UIImage(named: "conditionsButtonFull")
                } else {
                    bubble.image = UIImage(named: "conditionsButtonEmpty")
                }
                default: break
                }
                buttonsContainer.addSubview(bubble)
            }
        }
    }
    func poisonBadBacteria() {
        for bacteria in petrieDish.badBacterias {
            for bacteriocin in petrieDish.bacteriocins { //Running the loop through the subviews array
                if(bacteria.frame.intersects(bacteriocin.frame)){ //Checking the view is intersecting with other or not
                    //If intersected then return true
                    bacteriocin.removeFromSuperview()
                    bacteria.removeFromSuperview()
                    petrieDish.bacteriocins.removeObject(bacteriocin)
                    petrieDish.badBacterias.removeObject(bacteria)
                }
            }
        }
    }
    func moveAndReplicate() {
        petrieDish.move()
        petrieDish.replicate()
    }
}

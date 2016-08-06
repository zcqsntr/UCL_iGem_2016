//
//  gameViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 01/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

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
    
    
    @IBAction func panelSwitch(sender: UIButton) {
        switch sender.tag {
        case 0:
            conditionsView.hidden = false
            bacteriaView.hidden = true
            conditionsBubble.image = UIImage(named:"promoterBubble")
            //hide lightView
            
            break
        case 1:
            bacteriaView.hidden = false
            conditionsView.hidden = true
            conditionsBubble.image = UIImage(named:"genesBubble")
        case 2:
            //conditionsView.hidden = true
            //show lightView
            lightView.hidden = !lightView.hidden
            petrieDish.lightIsOn = !petrieDish.lightIsOn!
        default: break
        }
    }
    
    //function attached to conditions buttons
    @IBAction func conditionChange(sender: UIButton) {
        switch sender.tag {
            
        case 0: if petrieDish.PH > 1 {petrieDish.PH! -= 1}
        case 1: if petrieDish.PH < 9 {petrieDish.PH! += 1}
        case 2:if petrieDish.temperature > 1 {petrieDish.temperature! -= 1}
        case 3: if petrieDish.temperature < 9 {petrieDish.temperature! += 1}
        default: break
        }
        loadConditions()
    }
    
    //get biobrick from palsmid editor
    @IBAction func unwindToGameView(sender:UIStoryboardSegue){
        let previousVC = sender.sourceViewController as! editPlasmidViewController
        self.bioBrick = previousVC.bioBrick
        let activateTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("getActiveGenes"), userInfo: nil, repeats: true)
    }
    
    
    override func viewDidLoad() {
        collision = UICollisionBehavior(items: petrieDish.badBacterias)
        animator = UIDynamicAnimator(referenceView: self.view)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionMode = UICollisionBehaviorMode.Boundaries
        animator.addBehavior(collision)
        
        collision.collisionDelegate = self
        petrieDish.PH = 4
        petrieDish.temperature = 4
        petrieDish.lightIsOn = false
        loadConditions()
        if bioBrick == nil {
            bioBrick = []
        }
        
        goodBacteria.type = "good"
        badBacteria.type = "bad"
        goodBacteria.userInteractionEnabled = true
        badBacteria.userInteractionEnabled = true
        goodBacteria.delegate = self
        badBacteria.delegate = self
        
        let activateTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("getActiveGenes"), userInfo: nil, repeats: true)
        let moveAndReplicateTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("moveAndReplicate"), userInfo: nil, repeats: true)
        
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint){
        (item1 as! UIImageView).removeFromSuperview()
        (item2 as! UIImageView).removeFromSuperview()
    }
    
    //called when bacteria dropped
    
    func bacteriaBropped(bacteria: Bacteria) {
        let newBacteria = Bacteria()
        let pointInSuperview = self.view.convertPoint(bacteria.center, fromView: bacteria.superview)
        print("superview:\(pointInSuperview)")
        let pointInPetrieDish = self.petrieDish.convertPoint(pointInSuperview, fromView: self.view)
        print("petrieDish:\(pointInPetrieDish)")
        
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
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //self.petrieDish.addBacteria()
        //self.petrieDish.startMovement()
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
                default: break
                }
                
            } else if (fragment is Producer || fragment is Reporter) && currentlyActive {
                activeGenes!.append(fragment)
                
            } else if fragment is Repressor {
                currentlyActive = false
            }
        }
        //print(petrieDish.PH, petrieDish.temperature)
        
        activateGenes(activeGenes!)
    }
    
    func activateGenes(activeGenes:[DNAFragment]) {
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
        for i in 0...4 {
            for j in 0...8 {
                let bubble = UIImageView(frame: CGRect(x: CGFloat(j*34), y: 5 + CGFloat(i*45), width: CGFloat(27), height: CGFloat(27)))
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
                default: break
                }
                buttonsContainer.addSubview(bubble)
            }
        }
        
    }
    
    //move and replicate bacteria on petridish
    func moveAndReplicate() {
        petrieDish.move()
        petrieDish.replicate()
        for bacteria in petrieDish.badBacterias {
            collision.addItem(bacteria)
        }
        for bacteriocin in petrieDish.bacteriocins {
            collision.addItem(bacteriocin)
        }
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
      
    }
}

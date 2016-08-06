//
//  editPlasmidViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 01/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class editPlasmidViewController: UIViewController, DNAFragmentDelegate {
    
    //MARK: Setup
    
    var bioBrick:[DNAFragment]?
    
    @IBOutlet var editPlasmidView: UIView!
    @IBOutlet weak var panel: UIImageView!
    @IBOutlet weak var plasmid: UIImageView!
    //var promoterPairs:[[(DNAFragment,DNAFragment)]]?
    
    var panelShowing: String?
    var isFirstLoad = true
    @IBOutlet weak var enzymeViewContainer: UIView!
    @IBOutlet weak var EcoR1Button: UIButton!
    @IBOutlet weak var Xba1Button: UIButton!
    @IBOutlet weak var Spe1Button: UIButton!
    @IBOutlet weak var Pst1Button: UIButton!
    
    @IBAction func performLigation() {
        ligate()
        justBeenCut = false
    }
    
    
    @IBAction func performDigest() {
        if !justBeenCut {
            restrict()
        }
        justBeenCut = true
    }
 
    var enzymeButtons:[UIButton]?
    
    @IBAction func enzymeButtonPress(sender: UIButton) {
        sender.selected = !sender.selected
    }
    
    var genes:[[DoubleFragmentContainer]]?
    var reporters: [[DoubleFragmentContainer]]?
    var repressors:[[DoubleFragmentContainer]]?
    
    var promoterPairs:[[(DNAFragment, DNAFragment)]]?
    var genePairs:[[(DNAFragment, DNAFragment)]]?
    var reporterPairs:[[(DNAFragment, DNAFragment)]]?
    
    var promoterPairContainers:[[DoubleFragmentContainer]]?
    var genePairContainers:[[DoubleFragmentContainer]]?
    var reporterPairContainers:[[DoubleFragmentContainer]]?
    
    func createContainers(pairs:[[(DNAFragment, DNAFragment)]]) -> [[DoubleFragmentContainer]] {
        var pairContainers:[[DoubleFragmentContainer]] = [[]]
        for array in pairs {
            var containerArray:[DoubleFragmentContainer] = []
            for tuple in array {
                let leftFragment = tuple.0
                let rightFragment = tuple.1
                let container = DoubleFragmentContainer(frame: CGRectMake(0, 0, fragWidth + smallWidth - overhang*2, fragHeight), leftFragment: leftFragment, rightFragment: rightFragment, overhang: overhang)
                containerArray.append(container)
            }
            pairContainers.append(containerArray)
        }
        return pairContainers
    }
  
    override func viewDidLoad() {
        
        
        bioBrick = [/*DNAFragment(image: UIImage(named: "blankFragment.png")!),
                    DNAFragment(image: UIImage(named: "blankFragment.png")!),
                    DNAFragment(image: UIImage(named: "blankFragment.png")!),
                    DNAFragment(image: UIImage(named: "blankFragment.png")!),
                    DNAFragment(image: UIImage(named: "blankFragment.png")!),*/
            RestrictionSites(name:"LeftRS",image: UIImage(named: "LeftRS.png")!, smallWidth: smallWidth, largeWidth: smallWidth + fragWidth - overhang*2, height: fragHeight, side:"left"),
            SmallFragment(name:"blankHalfFragment",image: UIImage(named: "blankHalfFragment.png")!, width: smallWidth, height: fragHeight),
            RestrictionSites(name:"RightRS",image: UIImage(named: "RightRS.png")!, smallWidth: smallWidth, largeWidth: smallWidth + fragWidth - overhang*2, height: fragHeight, side:"right")
        ]
        
        //set up pairs to be put into containers
        promoterPairs = [[
                (RestrictionSites(name:"coldSensitivePromoterLeftRSs", image: UIImage(named:"coldSensitivePromoterLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                    Promoter(name:"coldSensitivePromoter",image: UIImage(named:"coldSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "Temperature", threshold:1)),
                (Promoter(name:"coldSensitivePromoter",image: UIImage(named:"coldSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "Temperature", threshold:1),
                    RestrictionSites(name:"coldSensitivePromoterRightRSs", image: UIImage(named:"coldSensitivePromoterRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
                (RestrictionSites(name:"hotSensitivePromoterLeftRSs",image: UIImage(named:"hotSensitivePromoterLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                    Promoter(name:"hotSensitivePromoter",image: UIImage(named: "hotSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "Temperature", threshold:9)),
                (Promoter(name:"hotSensitivePromoter",image: UIImage(named:"hotSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "Temperature", threshold:9),
                    RestrictionSites(name:"coldSensitivePromoterRightRSs", image: UIImage(named:"hotSensitivePromoterRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right"))
                ],[
                (RestrictionSites(name:"acidSensitivePromoterLeftRSs",image: UIImage(named:"acidSensitivePromoterLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                    Promoter(name:"acidSensitivePromoter",image: UIImage(named:"acidSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "PH", threshold: 1)),
                (Promoter(name:"acidSensitivePromoter",image: UIImage(named:"acidSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "PH", threshold:1),
                    RestrictionSites(name:"acidSensitivePromoterRightRSs", image: UIImage(named:"acidSensitiveRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
                (RestrictionSites(name:"alkaliSensitivePromoterLeftRSs",image: UIImage(named:"alkaliSensitivePromoterLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                    Promoter(name:"alkaliSensitivePromoter",image: UIImage(named:"alkaliSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "PH", threshold: 9)),
                (Promoter(name:"alkaliSensitivePromoter",image: UIImage(named:"alkaliSensitivePromoter.png")!, width: fragWidth, height: fragHeight, activator: "PH", threshold:9),
                    RestrictionSites(name:"alkaliSensitivePromoterRightRSs", image: UIImage(named:"alkaliSensitivePromoterRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
            ],[
                (RestrictionSites(name: "greenSensitivePromoterLeftRSs", image: UIImage(named:"greenLightSensitivePromoterLeftRSs")!, smallWidth: smallWidth, largeWidth: fragWidth+smallWidth - overhang*2, height: fragHeight, side: "left"),
                Promoter(name: "greenSensitivePromoter'", image: UIImage(named:"greenLightSensitivePromoter")!, width: fragWidth, height: fragHeight, activator: "GreenLight", threshold: 0)),
                (Promoter(name: "greenSensitivePromoter'", image: UIImage(named:"greenLightSensitivePromoter")!, width: fragWidth, height: fragHeight, activator: "GreenLight", threshold: 0),
                    RestrictionSites(name: "greenSensitivePromoterRightRSs", image: UIImage(named:"greenLightSensitivePromoterRightRSs")!, smallWidth: smallWidth, largeWidth: fragWidth+smallWidth - overhang*2, height: fragHeight, side: "right"))
            ]]
       
        reporterPairs = [[
            (RestrictionSites(name:"GFPLeftRSs", image: UIImage(named:"GFPLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                Reporter(name: "GFP",image: UIImage(named:"GFP.png")!, width: fragWidth, height: fragHeight, colour: "Green")),
            (Reporter(name: "GFP",image: UIImage(named:"GFP.png")!, width: fragWidth, height: fragHeight, colour: "Green"),
                RestrictionSites(name:"GFPRightRSs", image: UIImage(named:"GFPRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
            (RestrictionSites(name:"RFPLeftRSs", image: UIImage(named:"RFPLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                Reporter(name:"RFP", image: UIImage(named:"RFP.png")!, width: fragWidth, height: fragHeight, colour: "Red")),
            (Reporter(name: "RFP",image: UIImage(named:"RFP.png")!, width: fragWidth, height: fragHeight, colour: "Red"),
                RestrictionSites(name:"RFPRightRSs", image: UIImage(named:"RFPRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
            ],[
            (RestrictionSites(name:"BFPLeftRSs", image: UIImage(named:"BFPLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                Reporter(name: "BFP", image: UIImage(named:"BFP.png")!, width: fragWidth, height: fragHeight, colour: "Blue")),
            (Reporter(name: "BFP",image: UIImage(named:"BFP.png")!, width: fragWidth, height: fragHeight, colour: "Blue"),
                RestrictionSites(name:"BFPRightRSs", image: UIImage(named:"BFPRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
            ]]
        
        genePairs = [[
            (RestrictionSites(name:"repressorLeftRSs", image: UIImage(named:"repressorLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                Repressor(name: "Repressor", image:UIImage(named: "repressor")!, width: fragWidth, height: fragHeight)),
            (Repressor(name: "Repressor", image:UIImage(named: "repressor")!, width: fragWidth, height: fragHeight),
                RestrictionSites(name:"repressorPromoterRightRSs", image: UIImage(named:"repressorRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
            ],[
            (RestrictionSites(name:"repressorLeftRSs", image: UIImage(named:"repressorLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                Producer(name: "bacteriocin", image: UIImage(named:"GFP")!, width: fragWidth, height: fragHeight, substance: "bacteriocin"))
            
            ]]
        
        reporterPairContainers = createContainers(reporterPairs!)
        promoterPairContainers = createContainers(promoterPairs!)
        genePairContainers = createContainers(genePairs!)
        
        panelShowing = "promoters"
        displayPanelFragments(promoterPairContainers!)
        isFirstLoad = false

        displayPlasmid(bioBrick!)
        
        //set up buttons
        enzymeButtons = [EcoR1Button, Xba1Button, Spe1Button, Pst1Button]
        EcoR1Button.setImage(UIImage(named:"EcoR1Selected"), forState: UIControlState.Selected)
        Xba1Button.setImage(UIImage(named:"XbalSelected"), forState: UIControlState.Selected)
        Spe1Button.setImage(UIImage(named:"SpeSelected"), forState: UIControlState.Selected)
        Pst1Button.setImage(UIImage(named:"PstSelected"), forState: UIControlState.Selected)
    }
    
    //MARK: Biobrick management
    //unwinds to petriedish view
    @IBAction func save() {
        
    }
    
    func fragmentDropped(doubleFragment:DoubleFragmentContainer) {
        //align dropped fragment with empty space
        if let empty = getEmptySpace() {
            let xDist = abs(empty.center.x - doubleFragment.center.x)
            let yDist = abs(empty.center.y - doubleFragment.center.y)
            if xDist < 10 && yDist < 10 {
                doubleFragment.center = empty.center
                newFragment = doubleFragment
            }
        }
        
    }
    
    func getEmptySpace() -> RestrictionSites? {
        for fragment in bioBrick! {
            if let RS = fragment as? RestrictionSites {
                if RS.isCut {
                    return RS
                }
            }
        }
        return nil
    }
    
    //MARK: Display options panel
    func clearPanel() {
        switch panelShowing! {
        case "promoters":
            clearFragments(promoterPairContainers!)
        case "genes":
            clearFragments(genePairContainers!)
        case "reporters":
            clearFragments(reporterPairContainers!)
        case "enzymes":
            enzymeViewContainer.hidden = true
        default : break
        
        }
        
    }
    
    func displayPanelFragments(doubleFragments:[[DoubleFragmentContainer]]) {
        var x = -1 //x being weird, dont know why, start at -1 fixes
        for array in doubleFragments {
            var y = 0
            for fragmentContainer in array {
                fragmentContainer.delegate = self
                fragmentContainer.userInteractionEnabled = true
                if !fragmentContainer.hasBeenTouched {
                    fragmentContainer.center = CGPoint(x: x*180 + 90, y: y*50+30)
                    let pointInSuperView = panel.convertPoint(fragmentContainer.center, toView: editPlasmidView)
                    fragmentContainer.center = pointInSuperView
                }
                editPlasmidView.addSubview(fragmentContainer)
                y += 1
            }
        x += 1
        }
        
    }
    
    @IBAction func panelChanger(sender: UIButton) {
        if !isFirstLoad {
            clearPanel()
        }
        switch sender.tag {
            case 0:
                panel.image = UIImage(named:"promoterBubble.png") //show promoters
                displayPanelFragments(promoterPairContainers!)
                panelShowing = "promoters"
            case 1:
                panel.image = UIImage(named:"genesBubble.png") // show genes
                displayPanelFragments(genePairContainers!)
                panelShowing = "genes"
            case 2:
                panel.image = UIImage(named:"reportersBubble.png") // show reporters
                displayPanelFragments(reporterPairContainers!)
                panelShowing = "reporters"
            case 3:
                panel.image = UIImage(named:"enzymesBubble.png") //show REs
                enzymeViewContainer.hidden = false
                panelShowing = "enzymes"
            default: break
        }
    }
    
    func clearFragments(fragments: [[DoubleFragmentContainer]]) {
        for array in fragments {
            for fragment in array {
                if !fragment.hasBeenTouched { //need to get a better way to do this
                    fragment.removeFromSuperview()
                }
            }
        }
    }
    
    //MARK: Display Plasmid
    let smallWidth = CGFloat(50)
    let fragWidth = CGFloat(90)
    let fragHeight = CGFloat(20)
    let overhang = CGFloat(16)
    var numFragsOnRight = 0
    var numFragsOnLeft = 0
    var leftBuffer:UIImageView?
    var rightBuffer:UIImageView?
    
    func displayPlasmid(bioBrick :[DNAFragment]) {
        /// have the backgrund plasmid
        // on top of plasmid go trough biobrick and display fragments colorcoded depending on the RS and the type (promoter, reporter, gene etc)
        
        //display buffer
        //RSs start off in middle with three fragments either side 
        //need to display left and right buffer
        //left buffer size = plasmid gap/ 2 - size(RSs)/2 - noOfFragmentsOnLeft *size(fragment)
        //right buffer size = plasmid gap/ 2 - size(RSs)/2 - noOfFragmentsOnRight *size(fragment)
        //display rectangle buffers and the relevant RS
        if !isFirstLoad {
            leftBuffer?.removeFromSuperview()
            rightBuffer?.removeFromSuperview()
        }
        
        //from outer boudaries
        let gapWidth = 586
        let leftPlasmidStartOnScreen = CGPoint(x: 95, y: 256)
        let rightPlasmidStartOnScreen = CGPoint(x: 680, y: 256)
        //these converted points not working
        //let leftPlasmidStartOnPlasmid = plasmid.convertPoint(leftPlasmidStartOnScreen, toView: plasmid)
        //let rightPlasmidStartOnPlasmid = plasmid.convertPoint(rightPlasmidStartOnScreen, toView: plasmid)
        
        //set up buffers 
        rightBuffer = UIImageView(image: UIImage(named:"plasmidBuffer.png"))
        leftBuffer = UIImageView(image: UIImage(named:"plasmidBuffer.png"))
        
        let numOfOverhangsOnLeft = CGFloat(numFragsOnLeft + 2)
        let numOfOverhangsOnRight = CGFloat(numFragsOnRight + 2)
        
        
        let totalRight = fragWidth*CGFloat(numFragsOnRight)-overhang*numOfOverhangsOnRight
        let totalLeft = fragWidth*CGFloat(numFragsOnLeft)-overhang*numOfOverhangsOnLeft
        
        //                                      - the middle junk -the RSs -no of fragments on that side + buffer needed die to overhangs
        let rightBufferWidth = CGFloat(gapWidth)/2 - smallWidth * 1.5 - totalRight - overhang * 2 + 1
        let leftBufferWidth = CGFloat(gapWidth)/2 - smallWidth * 1.5 - totalLeft + overhang
        
        
        //change buffer
        leftBuffer!.frame = CGRectMake(leftPlasmidStartOnScreen.x, leftPlasmidStartOnScreen.y, leftBufferWidth, fragHeight)
        //for some reason right buffer needs +2, shoudnt be a problem
        rightBuffer!.frame = CGRectMake(CGFloat(rightPlasmidStartOnScreen.x-rightBufferWidth+2), rightPlasmidStartOnScreen.y, rightBufferWidth, fragHeight)
        
        
        editPlasmidView.addSubview(leftBuffer!)
        editPlasmidView.addSubview(rightBuffer!)
        
        //number of fragments + 1
        
    
        // display fragments
        var startPoint = CGPointMake(CGRectGetMaxX(leftBuffer!.frame), CGRectGetMinY(leftBuffer!.frame))
        var i = 0
        for fragment in bioBrick {
            /*fragment.image = nil
            fragment.backgroundColor = UIColor.clearColor()
            fragment.opaque = false */
            i += 1
            fragment.frame.origin = startPoint
            //let pointInSuperView = plasmid.convertPoint(fragment.center, toView: editPlasmidView)
            //fragment.center = pointInSuperView
            if fragment is SmallFragment {
                if fragment is RestrictionSites && (fragment as! RestrictionSites).isCut {
                    startPoint.x += smallWidth + fragWidth - (overhang * 3 - 1) //-1 to ensure RS is shown
                } else {
                    startPoint.x += smallWidth - overhang
                }
            } else {
                startPoint.x += fragWidth - overhang
            }
            editPlasmidView.addSubview(fragment)
        }
        bringRSsToFront()
    }
    
    func bringRSsToFront() {
        for fragment in bioBrick! {
            if fragment is RestrictionSites {
                self.editPlasmidView.bringSubviewToFront(fragment)
            }
        }
    }

   //MARK: Restriction
    var sideCurrentlyEditing:String?
    var justBeenCut = false
    
    func restrict() {
        var activeButtons:[UIButton] = []
        for button in enzymeButtons! {
            if button.selected == true {
                activeButtons.append(button)
                button.selected = false
            }
        }
        if activeButtons.contains(EcoR1Button) && activeButtons.contains(Xba1Button) {
            //perform left resriction
            numFragsOnLeft += 1
            makeCut("left")
            sideCurrentlyEditing = "left"
            //add RSs to either side of empty space
        } else if activeButtons.contains(Spe1Button) && activeButtons.contains(Pst1Button) {
            //perform right restriction
            numFragsOnRight += 1
            makeCut("right")
            sideCurrentlyEditing = "right"
        } else {
            //is not a valid restriction for biobrick
        }
        //return bioBrick with the cut RS set to an invisible skin with the width of a small plus large fragment
        displayPlasmid(bioBrick!)
    }
        
    
    func makeCut(side:String) {
        for fragment in bioBrick! {
            if fragment is RestrictionSites {
                let RSs = fragment as! RestrictionSites
                if RSs.side == side {
                    RSs.isCut = true
                    RSs.reloadImage()
                }
            }
        }
    }
    
    
    //MARK: Ligation
    var newFragment:DoubleFragmentContainer?
    func ligate() {
        //check the fragment has the right RSs and if so add it to the bioBrick
        if isValidLigation() {
            bioBrick?.append((newFragment?.leftFragment)!)
            bioBrick?.append((newFragment?.rightFragment)!)
            newFragment?.userInteractionEnabled = false
            removeOldRSs()
            bioBrick!.sortInPlace({$0.convertPoint($0.center, toView: editPlasmidView).x < $1.convertPoint($0.center, toView: editPlasmidView).x})
        }
        newFragment = nil
    }
    
    func removeOldRSs() {
        for fragment in bioBrick! {
            if let RS = fragment as? RestrictionSites {
                if RS.isCut {
                    bioBrick?.removeAtIndex((bioBrick?.indexOf(fragment))!)
                    RS.removeFromSuperview()
                }
            }
        }
    }
    
    func isValidLigation() -> Bool {
        switch sideCurrentlyEditing! {
        case "left":
            if newFragment?.leftFragment is RestrictionSites {
                newFragment?.otherRSRight.removeFromSuperview()
                return true
            }
        case "right":
            if newFragment?.rightFragment is RestrictionSites {
                newFragment?.otherRSLeft.removeFromSuperview()
                return true
            }
        default: break
        }
        return false
    }
    

}

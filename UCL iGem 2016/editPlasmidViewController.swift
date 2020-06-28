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
    var panelShowing: String?
    var isFirstLoad = true
    @IBOutlet weak var enzymeViewContainer: UIView!
    @IBOutlet weak var EcoR1Button: UIButton!
    @IBOutlet weak var Xba1Button: UIButton!
    @IBOutlet weak var Spe1Button: UIButton!
    @IBOutlet weak var Pst1Button: UIButton!
    
    var genes:[[DoubleFragmentContainer]]?
    var reporters: [[DoubleFragmentContainer]]?
    var repressors:[[DoubleFragmentContainer]]?
    
    var promoterPairs:[[(DNAFragment, DNAFragment)]]?
    var genePairs:[[(DNAFragment, DNAFragment)]]?
    var reporterPairs:[[(DNAFragment, DNAFragment)]]?
    
    var promoterPairContainers:[[DoubleFragmentContainer]]?
    var genePairContainers:[[DoubleFragmentContainer]]?
    var reporterPairContainers:[[DoubleFragmentContainer]]?
    
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
    
    @IBAction func enzymeButtonPress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    func createContainers(_ pairs:[[(DNAFragment, DNAFragment)]]) -> [[DoubleFragmentContainer]] {
        var pairContainers:[[DoubleFragmentContainer]] = [[]]
        for array in pairs {
            var containerArray:[DoubleFragmentContainer] = []
            for tuple in array {
                let leftFragment = tuple.0
                let rightFragment = tuple.1
                let container = DoubleFragmentContainer(frame: CGRect(x: 0, y: 0, width: fragWidth + smallWidth - overhang*2, height: fragHeight), leftFragment: leftFragment, rightFragment: rightFragment, overhang: overhang)
                containerArray.append(container)
            }
            pairContainers.append(containerArray)
        }
        return pairContainers
    }
    override func viewDidLoad() {
        
        bioBrick = [
            RestrictionSites(name:"LeftRS",image: UIImage(named: "LeftRS.png")!, smallWidth: smallWidth, largeWidth: smallWidth + fragWidth - overhang*2, height: fragHeight, side:"left"),
            SmallFragment(name:"blankHalfFragment",image: UIImage(named: "blankHalfFragment.png")!, width: smallWidth, height: fragHeight),
            RestrictionSites(name:"RightRS",image: UIImage(named: "RightRS.png")!, smallWidth: smallWidth, largeWidth: smallWidth + fragWidth - overhang*2, height: fragHeight, side:"right")
        ]
        
        promoterPairs = [[ //set up pairs to be put into containers
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
                    RestrictionSites(name:"alkaliSensitivePromoterRightRSs", image: UIImage(named:"alkaliSensitivePromoterRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right"))
                ],[
                (RestrictionSites(name: "greenSensitivePromoterLeftRSs", image: UIImage(named:"greenLightSensitivePromoterLeftRSs")!, smallWidth: smallWidth, largeWidth: fragWidth+smallWidth - overhang*2, height: fragHeight, side: "left"),
                Promoter(name: "greenSensitivePromoter'", image: UIImage(named:"greenLightSensitivePromoter")!, width: fragWidth, height: fragHeight, activator: "GreenLight", threshold: 0)),
                (Promoter(name: "greenSensitivePromoter'", image: UIImage(named:"greenLightSensitivePromoter")!, width: fragWidth, height: fragHeight, activator: "GreenLight", threshold: 0),
                    RestrictionSites(name: "greenSensitivePromoterRightRSs", image: UIImage(named:"greenLightSensitivePromoterRightRSs")!, smallWidth: smallWidth, largeWidth: fragWidth+smallWidth - overhang*2, height: fragHeight, side: "right")),
                (RestrictionSites(name:"highSugarPromoterLeftRSs", image: UIImage(named:"highSugarPromoterLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                    Promoter(name:"highSugarPromoter",image: UIImage(named:"highSugarPromoter.png")!, width: fragWidth, height: fragHeight, activator: "Sugar", threshold:9)),
                (Promoter(name:"highSugarPromoter",image: UIImage(named:"highSugarPromoter.png")!, width: fragWidth, height: fragHeight, activator: "Sugar", threshold:9),
                    RestrictionSites(name:"highSugarPromoterRightRSs", image: UIImage(named:"highSugarPromoterRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right"))
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
            (RestrictionSites(name:"bacteriocinLeftRSs", image: UIImage(named:"bacteriocinLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                Producer(name: "bacteriocin", image: UIImage(named:"bacteriocinFrag")!, width: fragWidth, height: fragHeight, substance: "bacteriocin")),
            (Producer(name: "bacteriocin", image: UIImage(named:"bacteriocinFrag")!, width: fragWidth, height: fragHeight, substance: "bacteriocin"),
                RestrictionSites(name:"bacteriocinRightRSs", image: UIImage(named:"bacteriocinRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right")),
            (RestrictionSites(name:"insulinLeftRSs", image: UIImage(named:"insulinLeftRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"left"),
                Producer(name: "insulin", image: UIImage(named:"insulinFrag")!, width: fragWidth, height: fragHeight, substance: "insulin")),
            (Producer(name: "insulin", image: UIImage(named:"insulinFrag")!, width: fragWidth, height: fragHeight, substance: "insulin"),
                RestrictionSites(name:"insulinRightRSs", image: UIImage(named:"insulinRightRSs.png")!, smallWidth: smallWidth,largeWidth: smallWidth+fragWidth - overhang*2, height: fragHeight, side:"right"))
            ]]
        reporterPairContainers = createContainers(reporterPairs!)
        promoterPairContainers = createContainers(promoterPairs!)
        genePairContainers = createContainers(genePairs!)
        panelShowing = "promoters"
        displayPanelFragments(promoterPairContainers!)
        isFirstLoad = false
        displayPlasmid(bioBrick!)
        
        enzymeButtons = [EcoR1Button, Xba1Button, Spe1Button, Pst1Button] //set up buttons
        EcoR1Button.setImage(UIImage(named:"EcoR1Selected"), for: UIControlState.selected)
        Xba1Button.setImage(UIImage(named:"XbalSelected"), for: UIControlState.selected)
        Spe1Button.setImage(UIImage(named:"SpeSelected"), for: UIControlState.selected)
        Pst1Button.setImage(UIImage(named:"PstSelected"), for: UIControlState.selected)
        
        //popups
        let plasmidPopup = Popup(frame: CGRect(x: plasmid.center.x-250, y: plasmid.center.y - 75, width: 500, height: 150) , text: "This is the plasmid .......")
        let DNAPopup = Popup(frame: CGRect(x: panel.center.x - 250, y: panel.center.y - 125, width: 500, height: 250), text: "This is the panel....")
        self.view.addSubview(plasmidPopup)
        self.view.addSubview(DNAPopup)
        
    }
    
    //MARK: Biobrick management
    @IBAction func save() {
        //unwinds to petriedish view
    }
    func fragmentDropped(_ doubleFragment:DoubleFragmentContainer) {
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
            enzymeViewContainer.isHidden = true
        default : break
        }
    }
    func displayPanelFragments(_ doubleFragments:[[DoubleFragmentContainer]]) {
        var x = -1 //x being weird, dont know why, start at -1 fixes
        for array in doubleFragments {
            var y = 0
            for fragmentContainer in array {
                fragmentContainer.delegate = self
                fragmentContainer.isUserInteractionEnabled = true
                if !fragmentContainer.hasBeenTouched {
                    fragmentContainer.center = CGPoint(x: x*180 + 90, y: y*50+30)
                    let pointInSuperView = panel.convert(fragmentContainer.center, to: editPlasmidView)
                    fragmentContainer.center = pointInSuperView
                }
                editPlasmidView.addSubview(fragmentContainer)
                y += 1
            }
        x += 1
        }
    }
    @IBAction func panelChanger(_ sender: UIButton) {
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
                enzymeViewContainer.isHidden = false
                panelShowing = "enzymes"
            default: break
        }
    }
    func clearFragments(_ fragments: [[DoubleFragmentContainer]]) {
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
    let overhang = CGFloat(17.5)
    var numFragsOnRight = 0
    var numFragsOnLeft = 0
    var leftBuffer:UIImageView?
    var rightBuffer:UIImageView?
    var leftBufferSquare:UIImageView?
    var rightBufferSquare:UIImageView?
   
    func displayPlasmid(_ bioBrick :[DNAFragment]) {
        if !isFirstLoad {
            leftBuffer?.removeFromSuperview()
            rightBuffer?.removeFromSuperview()
            leftBufferSquare?.removeFromSuperview()
            rightBufferSquare?.removeFromSuperview()
        }
        let centreOfPlasmid = CGPoint(x: 392.25, y: 270)
        let leftPlasmidStartOnScreen = CGPoint(x: 97, y: 256)
        
        let numOfOverhangsOnLeft = CGFloat(numFragsOnLeft + 1)
        let totalLeft = fragWidth*CGFloat(numFragsOnLeft)-overhang*numOfOverhangsOnLeft
    
        var startPoint = CGPoint(x: centreOfPlasmid.x-totalLeft-smallWidth*1.5-3, y: leftPlasmidStartOnScreen.y)
        //make left buffer
        leftBuffer = UIImageView(image: UIImage(named:"plasmidBuffer.png"))
        let leftBufferWidth = startPoint.x - leftPlasmidStartOnScreen.x
        leftBuffer!.frame = CGRect(x: leftPlasmidStartOnScreen.x, y: leftPlasmidStartOnScreen.y, width: leftBufferWidth, height: fragHeight)
        editPlasmidView.addSubview(leftBuffer!)
        leftBufferSquare = UIImageView(image: UIImage(named: "plasmidBuffer.png"))
        leftBufferSquare!.frame = CGRect(x: leftBuffer!.frame.maxX, y: leftBuffer!.frame.minY, width: overhang-2, height: fragHeight/2)
        editPlasmidView.addSubview(leftBufferSquare!)
        
        for fragment in bioBrick {
            fragment.frame.origin = startPoint
            
            if fragment is SmallFragment {
                //increment startPoint depending on how big each fragment is
                if fragment is RestrictionSites && (fragment as! RestrictionSites).isCut {
                    startPoint.x += smallWidth + fragWidth - (overhang*3) + 2 //-1 to ensure RS is shown
                } else {
                    startPoint.x += smallWidth - (overhang+2)
                }
            } else {
                startPoint.x += fragWidth - (overhang+2)
            }
            editPlasmidView.addSubview(fragment)
        }
        
        startPoint.x += overhang-2
        
        //add right buffer
        rightBuffer = UIImageView(image: UIImage(named:"plasmidBuffer.png"))
        
        let rightPlasmidStartOnScreen = CGPoint(x: 683.5, y: 256)
        let numOfOverhangsOnRight = CGFloat(numFragsOnRight + 1)
        let totalRight = fragWidth*CGFloat(numFragsOnRight)-overhang*numOfOverhangsOnRight
        let rightBufferWidth = rightPlasmidStartOnScreen.x - startPoint.x
        rightBuffer!.frame = CGRect(x: CGFloat(startPoint.x), y: rightPlasmidStartOnScreen.y, width: rightBufferWidth, height: fragHeight)
        editPlasmidView.addSubview(rightBuffer!)
        rightBufferSquare = UIImageView(image: UIImage(named: "plasmidBuffer.png"))
        rightBufferSquare!.frame = CGRect(x: rightBuffer!.frame.minX - overhang + 2, y: rightBuffer!.frame.minY + fragHeight/2, width: overhang-2, height: fragHeight/2)
        editPlasmidView.addSubview(rightBufferSquare!)
        
        bringRSsToFront()
    }
    func bringRSsToFront() {
        for fragment in bioBrick! {
            if fragment is RestrictionSites {
                self.editPlasmidView.bringSubview(toFront: fragment)
            }
        }
    }

   //MARK: Restriction
    var sideCurrentlyEditing:String?
    var justBeenCut = false
    
    func restrict() {
        var activeButtons:[UIButton] = []
        for button in enzymeButtons! {
            if button.isSelected == true {
                activeButtons.append(button)
                button.isSelected = false
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
    func makeCut(_ side:String) {
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
            newFragment?.isUserInteractionEnabled = false
            removeOldRSs()
            bioBrick!.sort(by: {$0.convert($0.center, to: editPlasmidView).x < $1.convert($0.center, to: editPlasmidView).x})
        } else {
            let badLigationPopup = Popup(frame: CGRect(x: self.view.frame.width/2 - 250/2, y: 100, width: 250, height: 100), text: "This is not a valid ligation")
            self.view.addSubview(badLigationPopup)
        }
        newFragment = nil
    }
    func removeOldRSs() {
        for fragment in bioBrick! {
            if let RS = fragment as? RestrictionSites {
                if RS.isCut {
                    bioBrick?.remove(at: (bioBrick?.index(of: fragment))!)
                    RS.removeFromSuperview()
                }
            }
        }
    }
    func isValidLigation() -> Bool {
        if let side = sideCurrentlyEditing {
            switch side {
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
            default: return false
            }
            newFragment!.center.y -= 10
            return false
        }
        return false
        
    }
}

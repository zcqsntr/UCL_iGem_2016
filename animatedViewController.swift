//
//  animatedViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 20/08/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class animatedViewController: UIViewController {
    @IBOutlet weak var bacteria: UIImageView!
    @IBOutlet weak var plasmid: UIImageView!
    var animationNumber:Int?
    @IBOutlet weak var restrictionSites: UIImageView!
    @IBOutlet weak var plasmidLeftCut: UIImageView!
    @IBOutlet weak var plasmidColdPromoterNonLigated: UIImageView!
    @IBOutlet weak var coldPromoter: UIImageView!
    @IBOutlet weak var plasmidWithColdPromoterLigated: UIImageView!
    @IBOutlet weak var plasmidRightIsCut: UIImageView!
    
    @IBOutlet weak var GFP: UIImageView!
    @IBOutlet weak var explanationLabel: UITextView!
    @IBOutlet weak var finishedPlasmid: UIImageView!

    
    
    @IBOutlet weak var ecoR1RE: UIImageView!
    @IBOutlet weak var xba1RE: UIImageView!
    @IBOutlet weak var spe1RE: UIImageView!
    @IBOutlet weak var pst1RE: UIImageView!
    
    
    @IBAction func next(_ sender: UIButton) {
        animate()
    }
    
    func animate() {
        switch animationNumber! {
        case 0: //show plasmid
            UIView.animate(withDuration: 0.5, animations: {
                self.plasmid.alpha = 100
            })
            self.explanationLabel.text = "Bacteria contain plasmids which house their DNA"
        case 1: //rotate and scale plasmid
            UIView.animate(withDuration: 0.5, animations: {
                self.bacteria.center.x -= self.view.frame.width
                self.plasmid.frame = CGRect(x: self.plasmid.frame.origin.x, y: self.plasmid.frame.origin.y, width: self.plasmid.frame.width * 3, height: self.plasmid.frame.height * 3)
                self.plasmid.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/3))
                self.plasmid.center.x = self.view.center.x
                self.plasmid.center.y -= 100
            })
        case 2: //show RSs
            restrictionSites.center.x = plasmid.center.x
            restrictionSites.frame.origin.y = self.view.center.y - 154
            UIView.animate(withDuration: 0.5, animations: {
                self.restrictionSites.alpha = 100
            })
            self.explanationLabel.text = "these are RSs...."
        case 3: //show restriction enzymes
            UIView.animate(withDuration: 0.5, animations: {
                self.xba1RE.alpha = 100
                self.ecoR1RE.alpha = 100
                self.pst1RE.alpha = 100
                self.spe1RE.alpha = 100
            })
            self.explanationLabel.text = "these are restriction enzymes, they cut the plasmid at their corresponding restriction site"
        case 4: //put RSs on left
            UIView.animate(withDuration: 0.5, animations: {
                self.ecoR1RE.center = CGPoint(x: self.restrictionSites.center.x - self.restrictionSites.frame.width/2,y: self.restrictionSites.center.y)
                self.xba1RE.center = CGPoint(x: self.restrictionSites.center.x-(self.restrictionSites.frame.width/2 - 20),y: self.restrictionSites.center.y)
            })
            self.explanationLabel.text = "If we want to add a fragment to the left, we cut the EcoR1 and Xba1 sites we create a gap, which we can fill with the desired genes"
        case 5:// cut left
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.plasmid.alpha = 0
                self.restrictionSites.alpha = 0
                self.ecoR1RE.alpha = 0
                self.xba1RE.alpha = 0
                }, completion: nil)
            
            UIView.animate(withDuration: 0.001, delay: 0.5, options: [], animations: {
                self.plasmidLeftCut.alpha = 100
                }, completion: nil)
            
        case 6: //show promoter
            UIView.animate(withDuration: 0.2, animations: {
                self.coldPromoter.alpha = 100
            })
            self.explanationLabel.text = "Here we are going to insert a promoter sensitive to low temperatures"
        case 7: //move promoter
            UIView.animate(withDuration: 0.5, animations: {
                self.coldPromoter.frame.origin = CGPoint(x: 303, y: 357)
            })
            self.explanationLabel.text = "we now need to use a ligase enzyme to ligate the DNA and seal the fragment in"
        case 8: //show ligated picture
            coldPromoter.isHidden = true
            plasmidLeftCut.isHidden = true
            plasmidColdPromoterNonLigated.alpha = 100
            plasmidWithColdPromoterLigated.alpha = 100
            UIView.animate(withDuration: 1, animations: {
                self.plasmidColdPromoterNonLigated.alpha = 0
            })
        case 9: self.explanationLabel.text = "You can see now that we have a biobrick witht the original RSs regenerated, this is key to allow subsequent fragments to be added"
        case 10: //cut right
            UIView.animate(withDuration: 0.5, animations: {
                self.plasmidWithColdPromoterLigated.alpha = 0
            })
            UIView.animate(withDuration: 0.001, delay: 0.5, options: [], animations: {
                self.plasmidRightIsCut.alpha = 100
                }, completion: nil)
            self.explanationLabel.text = "We can also add a fragment to the right side, by restricting with Spe1 and Pst1"
        case 11: //show GFP
            UIView.animate(withDuration: 0.5, animations: {
                self.GFP.alpha = 100
            })
            self.explanationLabel.text = "We will add Green Flourescent protein, this glows green when the bacteria produces it"
        case 12: //move GFP
            UIView.animate(withDuration: 0.5, animations: {
                self.GFP.frame.origin = CGPoint(x: 397, y: 358)
            })
        case 13: //Show finished
            UIView.animate(withDuration: 0.5, animations: {
                self.GFP.alpha = 0
                self.plasmidRightIsCut.alpha = 0
                self.finishedPlasmid.alpha = 100
            })
            self.explanationLabel.text = "We again ligate the fragment with DNA ligase to secure it into the biorbick"
        case 14:
            UIView.animate(withDuration: 0.5, animations: {
                self.bacteria.center.x += self.view.frame.width
                self.finishedPlasmid.frame = CGRect(x: self.finishedPlasmid.frame.origin.x, y: self.finishedPlasmid.frame.origin.y, width: self.finishedPlasmid.frame.width / 3, height: self.finishedPlasmid.frame.height / 3)
                self.finishedPlasmid.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI/3))
                self.finishedPlasmid.center.x = self.bacteria.center.x
                self.finishedPlasmid.center.y = self.bacteria.center.y
            })
            self.explanationLabel.text = "this biobrick can now be inserted back inside the bacteria, and the bacteria will contain our engineered plasmid"
        default:break
        }
        animationNumber! += 1
    }

    override func viewDidLoad() {
        animationNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bacteria.center.x -= self.view.frame.width
        plasmid.alpha = 0
        restrictionSites.alpha = 0
        plasmidLeftCut.alpha = 0
        plasmidColdPromoterNonLigated.alpha = 0
        coldPromoter.alpha = 0
        plasmidWithColdPromoterLigated.alpha = 0
        plasmidRightIsCut.alpha = 0
        GFP.alpha = 0
        finishedPlasmid.alpha = 0
        ecoR1RE.alpha = 0
        xba1RE.alpha = 0
        pst1RE.alpha = 0
        spe1RE.alpha = 0
        
        self.explanationLabel.text = "Most iGem work is done with bacteria"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, animations: {
            self.bacteria.isHidden = false
            self.bacteria.center.x += self.view.frame.width
        })
    }
}

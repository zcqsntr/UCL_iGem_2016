//
//  homescreenViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 16/09/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class homescreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["What is iGem?", "UCL iGem 2016: Biosynthage", "What is a Biobrick?", "Create your Own Biobrick"]
    let details = ["Background information about iGem", "Information about the various aspects of our project", "To help you understand how biobricks work", "A game where you can build your own biobrick and grow bacteria"]
    
    override func viewDidLoad() {
        tableView.isScrollEnabled = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "blueBackground.png"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.tintColor = UIColor.orange
    }
    
    // MARK: tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! iGemTableViewCell
        cell.backgroundView = UIImageView(image: UIImage(named:"blueBackground.png"))
        cell.titleLabel.text = titles[(indexPath as NSIndexPath).row]
        cell.detailLabel.text = details[(indexPath as NSIndexPath).row]
        cell.titleLabel.textColor = UIColor.white
        //cell.detailLabel.textColor = UIColor.orangeColor()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var segue:String!
        switch (indexPath as NSIndexPath).row {
        case 0: segue = "whatIsIGem"
        case 1: segue = "projectExplanations"
        case 2: segue = "whatIsABiobrick"
        case 3: segue = "game"
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: segue, sender: self)
    }

}



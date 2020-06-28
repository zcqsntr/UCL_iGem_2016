//
//  projectViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 01/07/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class projectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        tableView.isScrollEnabled = false
        text.isUserInteractionEnabled = false
        tableView.reloadData()
        tableView.isScrollEnabled = false
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ProjectDetailViewController
        destinationViewController.whichRow = (sender as! IndexPath).row
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "projectDetail", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell") as! iGemTableViewCell
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell.titleLabel.text = "Oxidative stress"
            cell.detailLabel.text = "The root of the problem"
        case 1:
            cell.titleLabel.text = "False teeth"
            cell.detailLabel.text = "A thing of the past"
        case 2:
            cell.titleLabel.text = "Grey love"
            cell.detailLabel.text = "It does not have to be dangerous"
        default:
            break
        }
        //cell.detailLabel.textColor = UIColor.orangeColor()
        cell.titleLabel.textColor = UIColor.white
        cell.backgroundView = UIImageView(image: UIImage(named: "blueBackground.png"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111.5
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Areas of Our Project"
//    }
}

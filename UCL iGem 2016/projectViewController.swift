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
        tableView.scrollEnabled = false
        text.userInteractionEnabled = false
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! ProjectDetailViewController
        destinationViewController.whichRow = sender?.row
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
        
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Areas of our Project"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("projectDetail", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Oxidative stress - the root of the problem"
        case 1:
            cell.textLabel?.text = "False teeth - a thing of the past"
        case 2:
            cell.textLabel?.text = "Grey love- it does not have to be dangerous"
        default:
            break
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
        return cell
        
    }
    
}

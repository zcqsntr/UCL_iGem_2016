//
//  biobrickViewController.swift
//  UCL iGem 2016
//
//  Created by Neythen Treloar on 17/08/2016.
//  Copyright © 2016 Neythen Treloar. All rights reserved.
//

import UIKit

class BiobrickInformationViewController: UIPageViewController, UIPageViewControllerDataSource  {
    
    var pages:[InformationViewController]!
    let numOfPages = 6
    let textContent = ["text1", "text2", "text3","text4","text5","text6"]
    let images:[UIImage?] = [UIImage(named:"bacteriaWithPlasmid"),UIImage(named:"plasmidWithRSs"),UIImage(named:"plasmidLeftCut"),UIImage(named:"plasmidRightIsCut"),UIImage(named:"plasmidNotLigated"),UIImage(named:"plasmidFinished")]
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let testVc = self.storyboard!.instantiateViewControllerWithIdentifier("testVC")
        dataSource = self
        pages = []
        for i in 0...numOfPages - 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "informationViewController") as! InformationViewController
           // vc.delegate = self
            vc.text = textContent[i]
            vc.image = images[i]
            pages.append(vc)
            
        }
        self.setViewControllers([viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
    }
    
    // MARK: Page View Controller Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if index > 0 {
            index -= 1
        }
        return viewControllerAtIndex(index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if index < numOfPages - 1 {
            index += 1
        }
        return viewControllerAtIndex(index)
    }
    func viewControllerAtIndex(_ index:Int) -> UIViewController {
        return pages[index]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int{
        return numOfPages
    }
   
    
}

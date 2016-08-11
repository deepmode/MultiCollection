//
//  MultiCollectionVC.swift
//  MultiCollection
//
//  Created by EricHo on 11/8/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit

struct Constants {
    static let BackgroundColor = UIColor.orangeColor()
    
    enum Section:Int {
        case FeatureBanner = 0
        case Category
        case Newsfeed
    }
}



class MultiCollectionVC: UIViewController {
    @IBOutlet weak var collectionView:UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Constants.BackgroundColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

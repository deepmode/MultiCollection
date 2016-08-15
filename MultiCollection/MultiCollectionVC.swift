//
//  MultiCollectionVC.swift
//  MultiCollection
//
//  Created by EricHo on 11/8/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit

enum SectionType:Int {
    
    case Feature = 0
    case Channel
    case Newsfeed
    case Unknown
    
    
    static func getSectionTypeWithRawValue(rawValue:Int) -> SectionType {
        switch rawValue {
        case 0:
            return SectionType.Feature
        case 1:
            return SectionType.Channel
        case 2:
            return SectionType.Newsfeed
        default:
            return SectionType.Unknown
        }
    }
}


struct Layout {
    
    static let interCellSpacingForCollectionView:CGFloat = 20.0
    
    static let cellTopPadding:CGFloat = interCellSpacingForCollectionView
    static let cellBottomPadding:CGFloat = interCellSpacingForCollectionView
    static let cellLeftPadding:CGFloat = interCellSpacingForCollectionView
    static let cellRightPadding:CGFloat = interCellSpacingForCollectionView
    
    static func numberOfColumn(sizeClass:UIUserInterfaceSizeClass) -> Int {
        switch sizeClass {
        case .Compact:
            return 2
        case .Regular:
            return 4
        default:
            return 1
        }
    }
    
    static func minimumLineSpacingForSection(sectionType:SectionType) -> CGFloat {
        switch sectionType {
        case .Feature:
            return 0.0
        case .Channel:
            return 0.0
        case .Newsfeed:
            return Layout.interCellSpacingForCollectionView
        case .Unknown:
            return 0.0
        }
    }
    
    static func sectionCellSize(containerWidth containerWidth:CGFloat, sectionType:SectionType, numberOfColumn:Int? = nil) -> CGSize {
        
        let interCellSpacing:CGFloat = Layout.interCellSpacingForCollectionView
        
        switch sectionType {
        case .Feature:
            return CGSizeMake(containerWidth, 250)
        case .Channel:
            return CGSizeMake(containerWidth, 100)
        case .Newsfeed:
            
            //default to single column
            var cols:CGFloat = 1.0
            
            if let numberOfColumn = numberOfColumn {
                cols = CGFloat(numberOfColumn)
            }
            
            let cellWidth = (containerWidth - ((cols + 1) * interCellSpacing)) / cols
            
            if cols > 1 {
                //fixed height
                return CGSizeMake(cellWidth, cellWidth)
            } else {
                let cellHeight = CGFloat(arc4random() % 150) + 100
                return CGSizeMake(cellWidth,cellHeight)
            }
        case .Unknown:
            return CGSizeMake(0,0)
        }
    }
    
    static func insetForSectionType(sectionType:SectionType) -> UIEdgeInsets {
        let leftPadding:CGFloat = Layout.cellLeftPadding
        let rightPadding:CGFloat = Layout.cellRightPadding
        let topPadding:CGFloat = Layout.cellTopPadding
        let bottomPadding:CGFloat = Layout.cellBottomPadding
        
        switch sectionType {
        case .Feature:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .Channel:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        case .Newsfeed:
            return UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding)
        case .Unknown:
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}


struct Constants {
    static let BackgroundColor = UIColor.greenColor()
    static let cellIdentifier = "CollectionViewCell"
    static let cellIdentifierFeature = "FeatureCell"
    static let numberOfSection = 3

}


func generateRandomData() -> [[UIColor]] {
    let numberOfRows = Constants.numberOfSection
    let numberOfItemsPerRow = 100
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}



class MultiCollectionVC: UIViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    //hold the latest size of VC's view bound
    private var currentSize:CGSize?
    
    private var featureSectionCell:FeatureCell?
    private var featureVC:FeatureVC?
    
    var dataSrc:[[UIColor]] = {
        
        var colors = [[UIColor]]()
        
        colors.append([UIColor.redColor()])
        
        colors.append([UIColor.orangeColor()])
        
        var temp = [UIColor]()
        for each in 0..<100 {
            temp.append(UIColor.randomColor())
        }
        colors.append(temp)
        return colors
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView?.backgroundColor = Constants.BackgroundColor
        
        self.collectionView.registerClass(FeatureCell.classForCoder(), forCellWithReuseIdentifier: Constants.cellIdentifierFeature)
        self.collectionView.registerNib(UINib(nibName: "FeatureCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier:Constants.cellIdentifierFeature)
        
        self.collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier:Constants.cellIdentifier)
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        if let layout  = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .Vertical
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        print("toSize: \(size)")
        //######################
        //self.currentSize (hold the latest size of VC's view bound)
        self.currentSize = size
        //######################
    
        
        var updateFrame = self.featureSectionCell?.frame
        updateFrame!.size.width = size.width
        self.featureSectionCell?.frame = updateFrame!
        
        if let flowlayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.invalidateLayout()
        }
        self.collectionView.reloadData()
    }
}

extension MultiCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        return Layout.insetForSectionType(sectionType)
        
        //return UIEdgeInsetsMake(Layout.cellTopPadding, Layout.cellLeftPadding, Layout.cellBottomPadding, Layout.cellRightPadding)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        //return self.collectionViewCellVerticalSeparatorSpacing //provide spacing between vertial cell
        
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
        return Layout.minimumLineSpacingForSection(sectionType)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.dataSrc.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSrc[section].count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let section = indexPath.section
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
    
        let column =  Layout.numberOfColumn(self.traitCollection.horizontalSizeClass)
        
        var size = Layout.sectionCellSize(containerWidth: width, sectionType: sectionType, numberOfColumn: column)
        if let newWidth  = self.currentSize?.width {
            size = Layout.sectionCellSize(containerWidth: newWidth, sectionType: sectionType, numberOfColumn: column)
        }
        return size
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let sectionType = SectionType.getSectionTypeWithRawValue(indexPath.section)
        switch sectionType {
        case .Feature:
            if self.featureSectionCell == nil {
                self.featureSectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.cellIdentifierFeature, forIndexPath: indexPath) as? FeatureCell
            }
            return self.featureSectionCell!
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.cellIdentifier, forIndexPath: indexPath) as! CollectionViewCell
            cell.backgroundColor = self.dataSrc[indexPath.section][indexPath.row]
            cell.setupCell("\(indexPath.row)")
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let sectionType = SectionType.getSectionTypeWithRawValue(indexPath.section)
        switch sectionType {
        case .Feature:
            if let featureCell = cell as? FeatureCell where self.featureVC == nil  {
                print("SectionType.FeatureBanner")
                if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SBID_FeatureVC") as? FeatureVC {
                    self.featureVC = vc
                    
                    //#######################
                    //controller containment
                    self.addChildViewController(vc)
                    self.featureVC?.didMoveToParentViewController(self)
                    
                    //must set to 0 in order to scroll the page properly
                    let topPadding:CGFloat = 0.0
                    let bottomPadding:CGFloat = 0.0
                    let leadingPadding:CGFloat = 0.0
                    let trailingPadding:CGFloat = 0.0
                    
                    let hostedView = vc.view
                    hostedView.frame = cell.frame
                    featureCell.contentView.addSubview(hostedView)
                    hostedView.translatesAutoresizingMaskIntoConstraints = false
                    
                    let topPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .Top, relatedBy: .Equal, toItem: featureCell.contentView, attribute: .Top, multiplier: 1.0, constant: topPadding)
                    let bottomPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .Bottom, relatedBy: .Equal, toItem: featureCell.contentView, attribute: .Bottom, multiplier: 1.0, constant: -bottomPadding)
                    let leadingPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .Leading, relatedBy: .Equal, toItem: featureCell.contentView, attribute: .Leading, multiplier: 1.0, constant: leadingPadding)
                    let trailingPaddingConstraint = NSLayoutConstraint(item: hostedView, attribute: .Trailing, relatedBy: .Equal, toItem: featureCell.contentView, attribute: .Trailing, multiplier: 1.0, constant: -trailingPadding)
                    
                    bottomPaddingConstraint.priority = 999
                    
                    NSLayoutConstraint.activateConstraints([topPaddingConstraint, bottomPaddingConstraint, leadingPaddingConstraint,trailingPaddingConstraint])
                    
                    //#######################
                    
                }
            }
        default:
            break
        }
    }
    
}

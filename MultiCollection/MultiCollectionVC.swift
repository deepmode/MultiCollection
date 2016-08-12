//
//  MultiCollectionVC.swift
//  MultiCollection
//
//  Created by EricHo on 11/8/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit

enum SectionType:Int {
    
    case FeatureBanner = 0
    case Channel
    case Newsfeed
    case Unknown
    
    
    static func getSectionTypeWithRawValue(rawValue:Int) -> SectionType {
        switch rawValue {
        case 0:
            return SectionType.FeatureBanner
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
            return 1
        case .Regular:
            return 4
        default:
            return 1
        }
    }
    
    static func minimumLineSpacingForSection(sectionType:SectionType) -> CGFloat {
        switch sectionType {
        case .FeatureBanner:
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
        case .FeatureBanner:
            return CGSizeMake(containerWidth, 300)
        case .Channel:
            return CGSizeMake(containerWidth, 140)
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
        case .FeatureBanner:
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
    static let BackgroundColor = UIColor.groupTableViewBackgroundColor()
    static let cellIdentifer = "CollectionViewCell"
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
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView?.backgroundColor = Constants.BackgroundColor
        
        
        self.collectionView.registerClass(CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: Constants.cellIdentifer)
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
        print("indexPath.section: \(indexPath.section)")
        
        let width = collectionView.bounds.width
        let section = indexPath.section
        let sectionType = SectionType.getSectionTypeWithRawValue(section)
    
        let column =  Layout.numberOfColumn(self.traitCollection.horizontalSizeClass)
        
        return Layout.sectionCellSize(containerWidth: width, sectionType: sectionType, numberOfColumn: column)
    }
    
 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.cellIdentifer, forIndexPath: indexPath)
        
        cell.backgroundColor = dataSrc[indexPath.section][indexPath.row]
        
        return cell
    }
    
    
}

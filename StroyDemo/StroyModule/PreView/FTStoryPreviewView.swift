//
//  FTStoryPreviewView.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import UIKit

public enum FTStroyLayoutType {
    case cubic
    var animator: FTLayoutAttributesAnimator {
        switch self {
            case .cubic:return FTCubeAttributesAnimator(perspective: -1/100, totalAngle: .pi/12)
        }
    }
}

class FTStoryPreviewView: UIView {

    //MARK:- iVars
    var layoutType: FTStroyLayoutType?
    /**Layout Animate options(ie.choose which kinda animation you want!)*/
    lazy var layoutAnimator: (FTLayoutAttributesAnimator, Bool, Int, Int) = (layoutType!.animator, true, 1, 1)
    lazy var snapsCollectionViewFlowLayout: FTAnimatedCollectionLayout = {
        let flowLayout = FTAnimatedCollectionLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.animator = layoutAnimator.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        return flowLayout
    }()
    
    lazy var snapsCollectionView: UICollectionView! = {
        let cv = UICollectionView.init(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height:  UIScreen.main.bounds.height), collectionViewLayout: snapsCollectionViewFlowLayout)
        cv.backgroundColor = .black
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(FTStoryPreviewCell.self, forCellWithReuseIdentifier: FTStoryPreviewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isPagingEnabled = true
        cv.isPrefetchingEnabled = false
        cv.collectionViewLayout = snapsCollectionViewFlowLayout
        return cv
    }()
    
    //MARK:- Overridden functions
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(layoutType: FTStroyLayoutType) {
        self.init()
        self.layoutType = layoutType
        createUIElements()
        installLayoutConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Private functions
    private func createUIElements(){
        backgroundColor = .black
        addSubview(snapsCollectionView)
    }
    private func installLayoutConstraints(){
        //Setting constraints for snapsCollectionview
        NSLayoutConstraint.activate([
            igLeftAnchor.constraint(equalTo: snapsCollectionView.igLeftAnchor),
            igTopAnchor.constraint(equalTo: snapsCollectionView.igTopAnchor),
            snapsCollectionView.igRightAnchor.constraint(equalTo: igRightAnchor),
            snapsCollectionView.igBottomAnchor.constraint(equalTo: igBottomAnchor)])
    }
}

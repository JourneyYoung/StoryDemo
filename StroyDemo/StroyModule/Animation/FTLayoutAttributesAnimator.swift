//
//  FTLayoutAttributesAnimator.swift
//  FTAnimatedCollectionLayout
//
//  Created by Journey on 28/11/2020.
//  Copyright © 2020 Journey. All rights reserved.
//

import UIKit

public protocol FTLayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}

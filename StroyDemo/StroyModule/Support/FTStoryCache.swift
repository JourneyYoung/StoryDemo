//
//  FTStoryCache.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import Foundation

//缓存相关
fileprivate let ONE_HUNDRED_MEGABYTES = 1024 * 1024 * 100

class FTStroyCache: NSCache<AnyObject, AnyObject> {
    static let shared = FTStroyCache()
    private override init() {
        super.init()
        self.setMaximumLimit()
    }
}

extension FTStroyCache {
    func setMaximumLimit(size: Int = ONE_HUNDRED_MEGABYTES) {
        totalCostLimit = size
    }
}

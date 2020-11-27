//
//  FTStoryPreviewModel.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import Foundation

class FTStoryPreviewModel: NSObject {

    let stories: [FTStoryArticleModel]
    let handPickedStoryIndex: Int //starts with(i)
    
    //MARK:- Init method
    init(_ stories: [FTStoryArticleModel], _ handPickedStoryIndex: Int) {
        self.stories = stories
        self.handPickedStoryIndex = handPickedStoryIndex
    }
    
    //MARK:- Functions
    func numberOfItemsInSection(_ section: Int) -> Int {
            return stories.count
    }
    func cellForItemAtIndexPath(_ indexPath: IndexPath) -> FTStoryArticleModel? {
        if indexPath.item < stories.count {
            return stories[indexPath.item]
        }else {
            fatalError("Stories Index mis-matched :(")
        }
    }

}

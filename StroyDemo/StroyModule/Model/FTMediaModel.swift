//
//  FTMediaModel.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import Foundation

public enum MediaType: String {
    case image
    case video
    case unknown
}

class FTMediaModel : NSObject{
    //流媒体类型
    public var mediaType : String?
    //流媒体链接
    public var url: String?
    //是否要pro才能播放
    public var isPro : Bool?
    
    public var type: MediaType {
        switch mediaType {
            case MediaType.image.rawValue:
                return MediaType.image
            case MediaType.video.rawValue:
                return MediaType.video
            default:
                return MediaType.unknown
        }
    }
    
    init(dict : Dictionary<String,String>) {
        
    }
}

//文章模型
class FTStoryArticleModel : NSObject{
    
    public var mediaList : [FTMediaModel]?
    
    public var mediaCount : Int{
        return mediaList?.count ?? 0
    }
    
    public var internalIdentifier : String = ""
    
    var lastPlayedMediaIndex = 0
    //是否完成展示
    var isCompletelyVisible = false
    //是否突然取消
    var isCancelledAbruptly = false
    
    //点赞数
    public var praiseNumber : Bool?
    //是否点赞
    public var isPraised : Bool?
    //是否收藏
    public var isFavorite : Bool?
    
    init(dict : Dictionary<String,Any>) {
        
        
        
    }
}

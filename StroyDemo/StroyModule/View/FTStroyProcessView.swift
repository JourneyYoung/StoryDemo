//
//  FTStroyProcessView.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import UIKit

public enum ProgressorState {
    //加载中
    case prepared
    //暂停中，目前是没有这种状态的
    case paused
    //播放中
    case running
    //播放完成
    case finished
}

protocol FTProcessAnimator {
    //开始
    func start(with duration: TimeInterval, holderView: UIView, completion: @escaping (_ storyIdentifier: String, _ snapIndex: Int, _ isCancelledAbruptly: Bool) -> Void)
    //继续播放
    func resume()
    //暂停
    func pause()
    //停止
    func stop()
    //重置
    func reset()
}

extension FTProcessAnimator where Self : FTStroyProcessView{
    
    func start(with duration: TimeInterval, holderView: UIView, completion: @escaping (_ storyIdentifier: String, _ snapIndex: Int, _ isCancelledAbruptly: Bool) -> Void) {
        // Modifying the existing widthConstraint and setting the width equalTo holderView's widthAchor
        self.state = .running
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
        self.widthConstraint?.constant = holderView.width
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.superview?.layoutIfNeeded()
            }
        }) { [weak self] (finished) in
            self?.story.isCancelledAbruptly = !finished
            self?.state = .finished
            if finished == true {
                if let strongSelf = self {
                    return completion(strongSelf.story_identifier!, strongSelf.snapIndex!, strongSelf.story.isCancelledAbruptly)
                }
            } else {
                return completion(self?.story_identifier ?? "Unknown", self?.snapIndex ?? 0, self?.story.isCancelledAbruptly ?? true)
            }
        }
    }
    func resume() {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        state = .running
    }
    func pause() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        state = .paused
    }
    func stop() {
        resume()
        layer.removeAllAnimations()
        state = .finished
    }
    func reset() {
        state = .prepared
        self.story.isCancelledAbruptly = true
        self.widthConstraint?.isActive = false
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint?.isActive = true
    }
}

class FTStroyProcessView: UIView , FTProcessAnimator{
    
    public var story_identifier: String?
    public var snapIndex: Int?
    public var story: FTStoryArticleModel!
    public var widthConstraint: NSLayoutConstraint?
    public var state: ProgressorState = .prepared

}


class FTStoryProcessIndicatorView : UIView{
    
    public var widthConstraint: NSLayoutConstraint?
    
    public var leftConstraiant: NSLayoutConstraint?
    
    public var rightConstraiant: NSLayoutConstraint?
}

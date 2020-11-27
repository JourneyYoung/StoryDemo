//
//  FTStroyHeaderView.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import UIKit
import SnapKit

protocol FTStroyHeaderViewProtocol : class {
    func didTapCloseButton()
}

public let progressIndicatorViewTag = 100
public let progressViewTag = 200

class FTStroyHeaderView: UIView {
    
    public weak var delegate : FTStroyHeaderViewProtocol?
    
    fileprivate var progressView: UIView?
    
    fileprivate var mediasPerStory: Int = 0
    public var story:FTStoryArticleModel? {
        didSet {
            mediasPerStory  = (story?.mediaCount)!
        }
    }

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ic_close"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        return button
    }()
    
    public var getProgressView: UIView {
        if let progressView = self.progressView {
            return progressView
        }
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.progressView = v
        self.addSubview(self.getProgressView)
        return v
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setUI()
        applyShadowOffset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUI(){
        backgroundColor = .clear
        addSubview(getProgressView)
        addSubview(closeButton)
        
        let process = getProgressView
        process.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(10)
            make.left.right.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.height.equalTo(60)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    private func applyShadowOffset() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
    }
    
    private func applyProperties<T: UIView>(_ view: T, with tag: Int? = nil, alpha: CGFloat = 1.0) -> T {
        view.layer.cornerRadius = 1
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white.withAlphaComponent(alpha)
        if let tagValue = tag {
            view.tag = tagValue
        }
        return view
    }
    
    @objc func didTapClose(_ sender: UIButton) {
        delegate?.didTapCloseButton()
    }
    
    public func clearTheProgressorSubviews() {
        getProgressView.subviews.forEach { v in
            v.subviews.forEach{v in (v as! FTStroyProcessView).stop()}
            v.removeFromSuperview()
        }
    }
    
    public func clearAllProgressors() {
        clearTheProgressorSubviews()
        getProgressView.removeFromSuperview()
        self.progressView = nil
    }
    
    public func clearMediaProgressor(at index:Int) {
        getProgressView.subviews[index].removeFromSuperview()
    }
    
    public func createSnapProgressors(){
        print("Progressor count: \(getProgressView.subviews.count)")
        let padding: CGFloat = 8 //GUI-Padding
        let height: CGFloat = 3
        var pvIndicatorArray: [FTStoryProcessIndicatorView] = []
        var pvArray: [FTStroyProcessView] = []
        
        // Adding all ProgressView Indicator and ProgressView to seperate arrays
        for i in 0..<mediasPerStory{
            let pvIndicator = FTStoryProcessIndicatorView()
            pvIndicator.translatesAutoresizingMaskIntoConstraints = false
            getProgressView.addSubview(applyProperties(pvIndicator, with: i+progressIndicatorViewTag, alpha:0.2))
            pvIndicatorArray.append(pvIndicator)
            
            let pv = FTStroyProcessView()
            pv.translatesAutoresizingMaskIntoConstraints = false
            pvIndicator.addSubview(applyProperties(pv))
            pvArray.append(pv)
        }
        // Setting Constraints for all progressView indicators
        for index in 0..<pvIndicatorArray.count {
            let pvIndicator = pvIndicatorArray[index]
            if index == 0 {
                pvIndicator.leftConstraiant = pvIndicator.igLeftAnchor.constraint(equalTo: self.getProgressView.igLeftAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.igCenterYAnchor.constraint(equalTo: self.getProgressView.igCenterYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height)
                    ])
                if pvIndicatorArray.count == 1 {
                    pvIndicator.rightConstraiant = self.getProgressView.igRightAnchor.constraint(equalTo: pvIndicator.igRightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }else {
                let prePVIndicator = pvIndicatorArray[index-1]
                pvIndicator.widthConstraint = pvIndicator.widthAnchor.constraint(equalTo: prePVIndicator.widthAnchor, multiplier: 1.0)
                pvIndicator.leftConstraiant = pvIndicator.igLeftAnchor.constraint(equalTo: prePVIndicator.igRightAnchor, constant: padding)
                NSLayoutConstraint.activate([
                    pvIndicator.leftConstraiant!,
                    pvIndicator.igCenterYAnchor.constraint(equalTo: prePVIndicator.igCenterYAnchor),
                    pvIndicator.heightAnchor.constraint(equalToConstant: height),
                    pvIndicator.widthConstraint!
                    ])
                if index == pvIndicatorArray.count-1 {
                    pvIndicator.rightConstraiant = self.igRightAnchor.constraint(equalTo: pvIndicator.igRightAnchor, constant: padding)
                    pvIndicator.rightConstraiant!.isActive = true
                }
            }
        }
        // Setting Constraints for all progressViews
        for index in 0..<pvArray.count {
            let pv = pvArray[index]
            let pvIndicator = pvIndicatorArray[index]
            pv.widthConstraint = pv.widthAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([
                pv.igLeftAnchor.constraint(equalTo: pvIndicator.igLeftAnchor),
                pv.heightAnchor.constraint(equalTo: pvIndicator.heightAnchor),
                pv.igTopAnchor.constraint(equalTo: pvIndicator.igTopAnchor),
                pv.widthConstraint!
                ])
        }
    }
}

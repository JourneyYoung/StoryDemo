//
//  FTStorySupport.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import Foundation
import UIKit

public enum FTResult<V, E> {
    case success(V)
    case failure(E)
}

public enum FTError: Error, CustomStringConvertible {

    case invalidImageURL
    case downloadError

    public var description: String {
        switch self {
        case .invalidImageURL: return "Invalid Image URL"
        case .downloadError: return "Unable to download image"
        }
    }
}

//网络加载相关
class FTURLSession: URLSession {
    static let `default` = FTURLSession()
    private(set) var dataTasks: [URLSessionDataTask] = []
}

extension FTURLSession {
    func cancelAllPendingTasks() {
        dataTasks.forEach({
            if $0.state != .completed {
                $0.cancel()
            }
        })
    }

    func downloadImage(using urlString: String, completionBlock: @escaping ImageResponse) {
        guard let url = URL(string: urlString) else {
            return completionBlock(.failure(FTError.invalidImageURL))
        }
        dataTasks.append(FTURLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let result = data, error == nil, let imageToCache = UIImage(data: result) {
                FTStroyCache.shared.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                completionBlock(.success(imageToCache))
            } else {
                return completionBlock(.failure(error ?? FTError.downloadError))
            }
        }))
        dataTasks.last?.resume()
    }
}

extension Int {
    var toFloat: CGFloat {
        return CGFloat(self)
    }
}

extension Array {
     func sortedArrayByPosition() -> [Element] {
        return sorted(by: { (obj1 : Element, obj2 : Element) -> Bool in
            
            let view1 = obj1 as! UIView
            let view2 = obj2 as! UIView
            
            let x1 = view1.frame.minX
            let y1 = view1.frame.minY
            let x2 = view2.frame.minX
            let y2 = view2.frame.minY
            
            if y1 != y2 {
                return y1 < y2
            } else {
                return x1 < x2
            }
        })
    }
}

//UICollection相关
protocol CellConfigurer:class {
    static var nib: UINib {get}
    static var reuseIdentifier: String {get}
}

extension CellConfigurer {
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    static var reuseIdentifier: String{
        return String(describing: self)
    }
}

extension UICollectionViewCell: CellConfigurer {}
extension UITableViewCell: CellConfigurer {}

/*************************** UINIB<Extension> ************************************************/
extension UINib {
    class func nib(with name: String) -> UINib {
        return UINib(nibName: name, bundle: nil)
    }
}


struct FTAppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}



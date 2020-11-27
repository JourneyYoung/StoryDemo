//
//  FTImageRequestable.swift
//  StroyDemo
//
//  Created by Journey on 2020/11/27.
//

import Foundation

import UIKit

public typealias ImageResponse = (FTResult<UIImage, Error>) -> Void

protocol FTImageRequestable {
    func setImage(urlString: String, placeHolderImage: UIImage?, completionBlock: ImageResponse?)
}

extension FTImageRequestable where Self: UIImageView {

    func setImage(urlString: String, placeHolderImage: UIImage? = nil, completionBlock: ImageResponse?) {

        self.image = (placeHolderImage != nil) ? placeHolderImage! : nil
        self.showActivityIndicator()

        if let cachedImage = FTStroyCache.shared.object(forKey: urlString as AnyObject) as? UIImage {
            self.hideActivityIndicator()
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            guard let completion = completionBlock else { return }
            return completion(.success(cachedImage))
        }else {
            FTURLSession.default.downloadImage(using: urlString) { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.hideActivityIndicator()
                switch response {
                case .success(let image):
                    DispatchQueue.main.async {
                        strongSelf.image = image
                    }
                    guard let completion = completionBlock else { return }
                    return completion(.success(image))
                case .failure(let error):
                    guard let completion = completionBlock else { return }
                    return completion(.failure(error))
                }
            }
        }
    }
}

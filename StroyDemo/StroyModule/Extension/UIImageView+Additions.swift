import UIKit

enum ImageStyle: Int {
    case squared,rounded
}

typealias SetImageRequester = (FTResult<Bool,Error>) -> Void

extension UIImageView: FTImageRequestable {
    func setImage(url: String,
                  style: ImageStyle = .rounded,
                  completion: SetImageRequester? = nil) {
        image = nil

        //The following stmts are in SEQUENCE. before changing the order think twice :P
        isActivityEnabled = true
        layer.masksToBounds = false
        if style == .rounded {
            layer.cornerRadius = frame.height/2
            activityStyle = .white
        } else if style == .squared {
            layer.cornerRadius = 0
            activityStyle = .whiteLarge
        }
        
        clipsToBounds = true
        setImage(urlString: url) { (response) in
            if let completion = completion {
                switch response {
                case .success(_):
                    completion(FTResult.success(true))
                case .failure(let error):
                    completion(FTResult.failure(error))
                }
            }
        }
    }
}

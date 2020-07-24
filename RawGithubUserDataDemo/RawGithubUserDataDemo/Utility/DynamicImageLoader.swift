//
//  DynamicImageLoader.swift
//  Articles_Demo_Vanita
//
//  Created by Vanita Ladkat on 11/07/20.
//  Copyright © 2020 Vanita Ladkat. All rights reserved.
//

import UIKit
import Kingfisher

typealias ImageCompletionHandler = (_ image: UIImage?) -> Void

extension UIImageView {
    func setImage(from urlStr: String, placeHolder: UIImage?, imageCompletionHandler: @escaping ImageCompletionHandler) {
        guard let url = URL(string: urlStr) else {
            self.image = placeHolder
            return
        }
        self.kf.setImage(with: url, placeholder: placeHolder)
        self.kf.setImage(with: url, placeholder: placeHolder) { result in
            switch result {
            case .success(let retrieveImageResult):
                imageCompletionHandler(retrieveImageResult.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
}

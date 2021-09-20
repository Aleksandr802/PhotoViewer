//
//  UIImageViewExtension.swift
//  PhotoViewer
//
//  Created by Aleksandr Seminov on 11.09.2021.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imageUrl: String) {
        self.kf.setImage(with: URL(string: imageUrl))
    }
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image)
                case .failure:
                    imageCompletionHandler(nil)
                }
            }
        }
}


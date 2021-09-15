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
}

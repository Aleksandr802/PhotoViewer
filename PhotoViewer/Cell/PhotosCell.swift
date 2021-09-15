//
//  PhotoCell.swift
//  PhotoViewer
//
//  Created by Aleksandr Seminov on 11.09.2021.

import UIKit

class PhotosCell: UICollectionViewCell {

    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var photosTitleLabel: UILabel!
    @IBOutlet weak var photoIdLabel: UILabel!
    
    var photo: Photo! {
        didSet {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.layer.cornerRadius = 5
            self.photosTitleLabel.text = "author:" + " " + self.photo.author
            self.photoIdLabel.text = photo.id
            self.photosImageView.setImage(imageUrl: self.photo.download_url)
            self.photosImageView.layer.cornerRadius = 5
        }
    }
}

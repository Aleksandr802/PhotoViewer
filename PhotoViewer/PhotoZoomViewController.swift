//
//  ZoomPhotoViewController.swift
//  PhotoViewer
//
//  Created by Aleksandr Seminov on 17.09.2021.
//

import UIKit

class PhotoZoomViewController: UIViewController {
    
    var photoScrollView: PhotoScrollView!
    var photo: Photo?
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        photoScrollView = PhotoScrollView(frame: view.bounds)
        view.addSubview(photoScrollView)
        configurePhotoScrollView()
        self.imageUrl = photo?.download_url ?? ""
        self.navigationItem.title = photo?.id
        self.photoScrollView.set(imageUrl: self.imageUrl)
        photoScrollView.reloadInputViews()
    }
    
    func configurePhotoScrollView() {
        photoScrollView.translatesAutoresizingMaskIntoConstraints = false
        photoScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
}

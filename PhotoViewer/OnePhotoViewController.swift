//
//  OnePhotoViewController.swift
//  PhotoViewer
//
//  Created by Aleksandr Seminov on 15.09.2021.
//

import UIKit

class OnePhotoViewController: UIViewController {

    @IBOutlet weak var onePhotoImageView: UIImageView!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.onePhotoImageView.setImage(imageUrl: photo?.download_url ?? "")
        self.navigationItem.title = photo?.id
    }
 
}

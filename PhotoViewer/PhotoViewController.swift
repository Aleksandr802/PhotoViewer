//
//  ViewController.swift
//  PhotoViewer
//
//  Created by Aleksandr Seminov on 29.07.2021.
//

import UIKit
import Alamofire

class PhotoViewController: UIViewController {
    
    let basicQueryUrl = "https://picsum.photos/v2/list?"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        
    }
    
    private var photos: [Photo] = []
    var page = 0
    var fetchingMore = false
    var activityIndiator : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photo Viewer"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCell")
        self.collectionView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellWithReuseIdentifier: "LoadingCell")
        
        activityIndiator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.midX - 15, y: self.view.frame.height - 140, width: 30, height: 30))
        activityIndiator?.style = .large
        activityIndiator?.color = UIColor.white
        activityIndiator?.hidesWhenStopped = true
        activityIndiator?.backgroundColor = .clear
        activityIndiator?.layer.cornerRadius = 15
        self.view.addSubview(activityIndiator!)
        self.view.bringSubviewToFront(activityIndiator!)
        
        self.fetchData(page: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) && (!fetchingMore && page < 90) {
            activityIndiator?.startAnimating()
            self.view.bringSubviewToFront(activityIndiator!)
            page += 1
            print(page)
            fetchData(page: page)
        }  else if (offsetY < 0.0) && (!fetchingMore && page > 1) {
            activityIndiator?.startAnimating()
            self.view.bringSubviewToFront(activityIndiator!)
            page -= 1
            print(page)
            fetchData(page: page)
        }
    }
    
    private func fetchData(page: Int, limit: Int = 30) {
        fetchingMore = true
        print("Begin FetchData")
        let params = "page=" + "\(page)" + "&limit=" + "\(limit)"
        AF.request(basicQueryUrl + params, method: .get).responseDecodable(of: [Photo].self) { [weak self] response in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self?.photos = response.value ?? []
                self?.fetchingMore = false
                self?.collectionView.reloadData()
            }
        }
    }

}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        cell.photo = photos[indexPath.row]
        activityIndiator?.stopAnimating()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "OnePhotoViewController") as? OnePhotoViewController {
            vc.photo = photo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


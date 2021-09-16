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
    @IBAction func unwindToMain(segue: UIStoryboardSegue){
        
    }
    
    private var photos: [Photo] = []
    private var searchPhotos: [Photo] = []
    var page = 1
    var fetchingMore = false
    var activityIndiator : UIActivityIndicatorView?
    var isSearching = false
    
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
        
        self.fetchData(page: 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) && (!fetchingMore && page < 90) && !self.isSearching {
            activityIndiator?.startAnimating()
            self.view.bringSubviewToFront(activityIndiator!)
            page += 1
            print(page)
            fetchData(page: page)
        } else if (offsetY < 0.0) && (!fetchingMore && page > 1) && !self.isSearching {
            activityIndiator?.startAnimating()
            self.view.bringSubviewToFront(activityIndiator!)
            page -= 1
            print(page)
            fetchData(page: page)
        } else {
            return
        }
        
        self.collectionView?.reloadData()
    }
    
    private func fetchData(page: Int, limit: Int = 30) {
        fetchingMore = true
        let params = "page=" + "\(page)" + "&limit=" + "\(limit)"
        AF.request(basicQueryUrl + params, method: .get).responseDecodable(of: [Photo].self) { [weak self] response in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self?.photos = response.value ?? []
                self?.searchPhotos = self?.photos ?? []
                self?.fetchingMore = false
                self?.collectionView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.photos.removeAll()
        self.isSearching = true
        for item in self.searchPhotos {
            if item.author.lowercased().contains(searchBar.text!.lowercased()) {
                self.photos.append(item)
            } else if item.id.contains(searchBar.text!) {
                self.photos.append(item)
            }
        }
        
        if searchBar.text!.isEmpty {
            self.photos = self.searchPhotos
            self.isSearching = false
        }
        self.collectionView?.reloadData()
    }

}

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCell
        cell.photo = photos[indexPath.item]
        activityIndiator?.stopAnimating()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "OnePhotoViewController") as? OnePhotoViewController {
            vc.photo = photo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        
        let searchView: UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }
        
}

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
    private var page = 0
    private var fetchingMore = false
    private var spinner : UIActivityIndicatorView?
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photo Viewer"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PhotosCell", bundle: nil), forCellWithReuseIdentifier: "PhotosCell")
        self.collectionView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellWithReuseIdentifier: "LoadingCell")
        
        spinner = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.midX - 15, y: self.view.frame.height - 140, width: 30, height: 30))
        spinner?.style = .large
        spinner?.color = UIColor.white
        spinner?.hidesWhenStopped = true
        spinner?.backgroundColor = .clear
        spinner?.layer.cornerRadius = 15
        self.view.addSubview(spinner!)
        self.view.bringSubviewToFront(spinner!)
        
        self.fetchData(page: 1)
    }
    
    private func fetchData(page: Int, limit: Int = 10) {
        spinner?.startAnimating()
        self.view.bringSubviewToFront(spinner!)
        let params = "page=" + "\(page)" + "&limit=" + "\(limit)"
        
        if !fetchingMore {
            fetchingMore = true
            AF.request(basicQueryUrl + params, method: .get).responseDecodable(of: [Photo].self) { [weak self] response in
                guard self?.isSearching == false else {return}
                self?.page += 1
                print(page)
                self?.photos.append(contentsOf: response.value ?? [])
                self?.searchPhotos = self?.photos ?? []
                self?.collectionView.reloadData()
                self?.fetchingMore = false
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
        spinner?.stopAnimating()
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchData(page: page)
        }
        
    }
}

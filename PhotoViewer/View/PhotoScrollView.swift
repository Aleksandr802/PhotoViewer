//
//  OnePhotoZoomView.swift
//  PhotoViewer
//
//  Created by Aleksandr Seminov on 17.09.2021.
//

import UIKit

class PhotoScrollView: UIScrollView, UIScrollViewDelegate {

    var photoZoomView = UIImageView()
    var imageZoom = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerPhoto()
    }
    
    func set(imageUrl: String) {
        photoZoomView.removeFromSuperview()
        photoZoomView.setImage(imageUrl: imageUrl)
        photoZoomView.downloadImage(with: imageUrl) { image in
            guard let image = image else {return}
            self.imageZoom = image
        }
        photoZoomView.translatesAutoresizingMaskIntoConstraints = false
        photoZoomView.sizeToFit()
        contentSize = photoZoomView.bounds.size
        addSubview(photoZoomView)
        configureFor(photoSize: imageZoom.size)
        print("Photo Size: \(imageZoom.size)")
    }
    
    func configureFor(photoSize: CGSize) {
        self.contentSize = photoSize
        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale
    }
    
    func setCurrentMaxandMinZoomScale() {
        let boundsSize = self.bounds.size
        let photoSize = self.photoZoomView.bounds.size
        let xScale = boundsSize.width / photoSize.width
        let yScale = boundsSize.height / photoSize.height
        let minScale = min(xScale, yScale)
        var maxScale: CGFloat = 1.0
        
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.maximumZoomScale = maxScale
        self.minimumZoomScale = minScale
    }
    
    func centerPhoto() {
        let boundsSize = self.bounds.size
        var frameToCenter = self.photoZoomView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        photoZoomView.frame = frameToCenter
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let scale = min(self.zoomScale * 2, self.maximumZoomScale)

        if scale != self.zoomScale { // zoom in
            let point = recognizer.location(in: photoZoomView)

            let scrollSize = self.frame.size
            let size = CGSize(width: scrollSize.width / self.maximumZoomScale,
                              height: scrollSize.height / self.maximumZoomScale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            self.zoom(to:CGRect(origin: origin, size: size), animated: true)
        } else if self.zoomScale == 1 { //zoom out
            self.zoom(to: zoomRectForScale(scale: self.maximumZoomScale, center: recognizer.location(in: photoZoomView)), animated: true)
        }
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = photoZoomView.frame.size.height / scale
        zoomRect.size.width  = photoZoomView.frame.size.width  / scale
        let newCenter = self.convert(center, from: photoZoomView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    //MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoZoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerPhoto()
    }
}

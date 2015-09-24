//
//  FullScreenViewController.swift
//  Houzify
//
//  Created by Swagat Kumar Bisoyi on 9/23/15.
//  Copyright (c) 2015 Swagat Kumar Bisoyi. All rights reserved.
//

import UIKit


class FullScreenViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    var indexPassed : Int = 0
    var image : UIImage = UIImage()
    var lastZoomScale: CGFloat = -1
    var imageArray : NSMutableArray = NSMutableArray()
    
    var swipeRightRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var swipeLeftRecognizer : UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateView()
        updateViewConstraints()
        updateZoom()
    }
    
    
    func updateView()
    {
        image = imageArray[indexPassed-1] as! UIImage
        imageView.image = image
        scrollView.delegate = self
        updateZoom()
        
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        
        swipeLeftRecognizer.addTarget(self, action: "didSwipeLeft")
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.scrollView.addGestureRecognizer(swipeLeftRecognizer)
        swipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        swipeRightRecognizer.addTarget(self, action: "didSwipeRight")
        self.scrollView.addGestureRecognizer(swipeRightRecognizer)
        centerScrollViewContents()
        
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.locationInView(imageView)
        
        var newZoomScale = scrollView.zoomScale * 2.0
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    
    // Update zoom scale and constraints with animation.
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            
            coordinator.animateAlongsideTransition({ [weak self] _ in
                self?.updateZoom()
                }, completion: nil)
    }
    
    //
    // Update zoom scale and constraints with animation on iOS 7.
    //
    override func willAnimateRotationToInterfaceOrientation(
        toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
            
            super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
            updateZoom()
    }
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            if imageConstraintLeft != nil
            {
                imageConstraintLeft.constant = hPadding
                imageConstraintRight.constant = hPadding
                
                imageConstraintTop.constant = vPadding
                imageConstraintBottom.constant = vPadding
            }
            
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                scrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    
    func didSwipeLeft(){
        if indexPassed < imageArray.count
        {
            indexPassed++
            image = imageArray[indexPassed-1] as! UIImage
            updateView()
            
        }
        
        println("didSwipeLeft")
    }
    
    func didSwipeRight(){
        if indexPassed > 1
        {
            indexPassed--
            image = imageArray[indexPassed-1] as! UIImage
            updateView()
        }
    }
    
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }

    
    
}


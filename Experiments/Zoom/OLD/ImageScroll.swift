//
//  ImageScroll.swift
//  Experiments
//
//  Created by Sherzod on 3/5/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

protocol ImageSlideWithZoomDelegate
{
    func toggleZoomView(_ sender: SlideZoom)
}

class ImageSlideWithZoom: ImageScroll, ImageSlideWithZoomDelegate
{
    var inZoomView: Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleZoomViewGestureHandler(_:))))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let cell = cell as! ImageCell
        var height: CGFloat = 0
        var width: CGFloat = 0
        if let image = cell.img.image
        {
            for constraint in cell.img.constraints
            {
                if constraint.identifier == "imageHeight"
                {
                    if self.inZoomView
                    {
                        width = image.size.width
                        height = image.size.height
                        constraint.constant = cell.frame.width * height / width
                    }
                    else if self.imageViewHeightConstant != nil
                    {
                        constraint.constant = self.imageViewHeightConstant
                        cell.scrollView.setZoomScale(1, animated: false)
                    }
                }
            }
        }
        cell.centerImageView(collectionView, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! ImageCell
        cell.scrollView.delegate = cell
        cell.imageSlideWithZoomDelegate = self
        cell.inZoomView = self.inZoomView
        cell.scrollView.minimumZoomScale = self.inZoomView ? 0.1 : 1
        
        return cell
    }
    
    //Toggles zoom view. When collection view tapped goes to zoom view. Cell must be instance of ImageCell
    //These are to hold initial values of constraint that being changed.
    private var collectionViewTopConstant: CGFloat!
    private var collectionViewBottomConstant: CGFloat!
    private var collectionViewHeightConstant: CGFloat!
    private var imageViewHeightConstant: CGFloat!  //Height constrain of image view in cell
    private var blurBack: UIVisualEffectView?
    
    func toggleZoomView(_ sender: SlideZoom)
    {
        var deltaHeight: CGFloat = 0
        for constraint in sender.constraints
        {
            if constraint.identifier == "collectionHeight"
            {
                if !self.inZoomView
                {
                    self.collectionViewHeightConstant = constraint.constant
                    deltaHeight = UIScreen.main.bounds.height - constraint.constant
                    constraint.constant = UIScreen.main.bounds.height
                }
                else
                {
                    constraint.constant = self.collectionViewHeightConstant
                }
            }
        }
        
        for constraint in sender.superview!.constraints
        {
            if constraint.identifier == "collectionTop"
            {
                
            }
            else if constraint.identifier == "collectionBottom"
            {
                
                if !self.inZoomView
                {
                    self.collectionViewBottomConstant = constraint.constant
                    constraint.constant = -1 * (deltaHeight)
                }
                else
                {
                    constraint.constant = self.collectionViewBottomConstant
                }
            }
        }
        sender.collectionViewLayout.invalidateLayout()
        sender.superview!.layoutIfNeeded()  //Update collection view layout before cell content size change to make cell content autolayout right
        
        let cell = sender.visibleCells.first as! ImageCell
        cell.clipsToBounds = false
        cell.scrollView.clipsToBounds = false
        sender.clipsToBounds = false
        
        for constraint in cell.img.constraints
        {
            if constraint.identifier == "imageHeight"
            {
                if let image = cell.img.image
                {
                    if !self.inZoomView
                    {
                        self.imageViewHeightConstant = constraint.constant
                        let width = image.size.width
                        let height = image.size.height
                        constraint.constant = cell.frame.width * height / width
                    }
                    else
                    {
                        constraint.constant = self.imageViewHeightConstant
                    }
                }
            }
        }
        sender.collectionViewLayout.invalidateLayout()
        self.inZoomView = !self.inZoomView
        
        if !self.inZoomView
        {
            sender.blurBackBottom.constant = sender.frame.height - UIScreen.main.bounds.height
        }
        
        //Animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            cell.centerImageView(sender, for: IndexPath(item: 0, section: 0))
            cell.layoutIfNeeded()
            
            if !self.inZoomView
            {
                sender.blurBack.effect = nil
                cell.scrollView.zoomScale = 1
            }
            else
            {
                sender.blurBack.effect = UIBlurEffect(style: .light)
            }
            
        }, completion: {(success: Bool) in
            //cell.clipsToBounds = true
            //cell.scrollView.clipsToBounds = true
            //sender.clipsToBounds = true
            sender.blurBackBottom.constant = 0
            cell.inZoomView = self.inZoomView
            cell.scrollView.minimumZoomScale = self.inZoomView ? 0.1 : 1
        })
    }
    
    @objc func toggleZoomViewGestureHandler(_ gesture: UITapGestureRecognizer)
    {
        toggleZoomView(gesture.view as! SlideZoom)
    }
}

class ImageScroll: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    @IBOutlet var collectionView: UICollectionView!
    var cellShown: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        cell.img.image = UIImage(named: indexPath.row.description)
        cellShown = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
        //return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 10)
    }
}

class ImageCell: UICollectionViewCell, UIScrollViewDelegate
{
    @IBOutlet var img: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    var inZoomView: Bool = false
    var imageSlideWithZoomDelegate: ImageSlideWithZoomDelegate!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
    }
    
    private func setContentToCenter()
    {
        if scrollView.frame.height <= scrollView.contentSize.height
        {
            scrollView.contentInset.top = 0
            scrollView.contentInset.left = 0
        }
        else
        {
            self.scrollView.contentInset.top = self.frame.height / 2 - self.img.frame.height / 2
            self.scrollView.contentInset.left = self.frame.width / 2 - self.img.frame.width / 2
        }
    }
    
    func centerImageView(_ collectionView: UICollectionView, for indexPath: IndexPath)
    {
        self.layoutIfNeeded()
        setContentToCenter()
    }
    
    //Zoom function implementation for UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return self.img//self.inZoomView ? self.img : nil
    }
    
    private var didZoomInsetSet: Bool = false
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        setContentToCenter()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        if scale < 1
        {
            if let collectionView = self.superview as? SlideZoom
            {
                imageSlideWithZoomDelegate.toggleZoomView(collectionView)
            }
        }
        else if !self.inZoomView && scale != 1
        {
            if let collectionView = self.superview as? SlideZoom
            {
                imageSlideWithZoomDelegate.toggleZoomView(collectionView)
            }
        }
    }
}

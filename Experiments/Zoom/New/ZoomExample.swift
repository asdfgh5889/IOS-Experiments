//
//  ZoomExample.swift
//  Experiments
//
//  Created by Sherzod on 6/13/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

class ZoomExample: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet var collectionView: UICollectionView!
    var images = ["0","1","2" ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.tag = 21
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CellWithImage
        cell.image.image = UIImage(named: self.images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let image = (collectionView.cellForItem(at: indexPath) as! CellWithImage).image.image!
        let zoomController = ZoomCollectionViewController(self.images, image, collectionView.frame, indexPath)
        zoomController.modalPresentationStyle = .overCurrentContext
        present(zoomController, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

class ZoomCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionHeight: NSLayoutConstraint!
    
    var images = ["0","1","2" ]
    var bounceOffset: CGFloat = 50
    private var inZoom: Bool = false
    private var initialIndex: IndexPath = IndexPath(row: 0, section: 0)
    private var initialImage: UIImage!
    private var initialFrame: CGRect!
    private var blurBack: UIVisualEffectView!
    private var animImageView: UIImageView!
    private var animSnapshot: UIView?
    private var animImageOrigin: CGPoint?
    
    init(_ images: [String], _ currentImage: UIImage, _ collectoinViewFrame: CGRect, _ currentIndex: IndexPath, _ layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout())
    {
        
        self.images = images
        self.initialImage = currentImage
        self.initialIndex = currentIndex
        self.initialFrame = collectoinViewFrame
        
        self.collectionView = UICollectionView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero), collectionViewLayout: layout)
        self.animImageView = UIImageView(frame: CGRect.zero)
        self.animImageView.isHidden = true
        self.collectionView.tag = 11
        
        super.init(nibName: nil, bundle: nil)
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.isHidden = true
        layout.scrollDirection = .horizontal
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.animImageView)
        self.collectionHeight = Constraint.height(self.collectionView, collectoinViewFrame.height)
        self.view.addConstraints(Constraint.stickToSides(self.view, self.collectionView))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.blurBack = UIVisualEffectView(frame: self.view.frame)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ZoomCellWithImage.self, forCellWithReuseIdentifier: "imageCell")
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .clear
        
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(zoomDismissAnim(_:))))
        self.view.backgroundColor = .clear
        self.view.addSubview(self.blurBack)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        animate(self.initialImage)
    }
    
    fileprivate func animate(_ image: UIImage)
    {
        self.animImageView.isHidden = false
        self.animImageView.image = image
        self.animImageView.frame = self.initialFrame
        self.animImageView.contentMode = .scaleAspectFit
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.animImageView.frame.origin = CGPoint.zero
            self.animImageView.frame.size.height = self.view.frame.height
            self.blurBack.effect = UIBlurEffect(style: .dark)
        }, completion: { (_ : Bool) -> Void in
            self.collectionView.isHidden = false
            self.collectionView.scrollToItem(at: self.initialIndex, at: .centeredHorizontally, animated: false)
            self.animImageView.isHidden = true
        })
    }
    
    @objc fileprivate func zoomDismissAnim(_ gesture: UIPanGestureRecognizer)
    {
        var outOfZoomView: Bool = true
        if let scrollView = gesture.view as? UIScrollView
        {
            if scrollView.contentOffset.y + self.bounceOffset < 0 || scrollView.contentOffset.y - self.bounceOffset > scrollView.frame.height
            {
                outOfZoomView = true
            }
            else
            {
                outOfZoomView = false
            }
        }
        
        
        let velocity = gesture.velocity(in: self.view)
        
        if abs(velocity.y) > 800 && animSnapshot == nil && outOfZoomView
        {
            self.animSnapshot = self.collectionView.snapshotView(afterScreenUpdates: false)
            self.view.addSubview(self.animSnapshot!)
            self.collectionView.isHidden = true
            gesture.setTranslation(CGPoint.zero, in: self.view)
        }
        else if animSnapshot != nil
        {
            let translation = gesture.translation(in: self.view)
            let panTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
            self.animSnapshot!.transform = panTransform
            
            if gesture.state == .ended
            {
                print(self.animSnapshot!.layer.position)
                
                UIView.animate(withDuration: 0.3, animations: {
                    let transform = CGAffineTransform(
                        translationX: (velocity.x > 0 ? 1: -1) * (self.view.frame.width + 10),
                        y: (velocity.y > 0 ? 1: -1) * (self.view.frame.height + 10))
                    
                    transform.scaledBy(x: 0.1, y: 0.1)
                    self.animSnapshot!.transform = transform
                    
                    self.blurBack.alpha = 0
                }) { (_: Bool) in
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    fileprivate func calculateCellConstraints(_ cell: ZoomCellWithImage)
    {
        if let height = cell.imageHeightConstraint
        {
            if let image = cell.image.image
            {
                let imgwidth = image.size.width
                let imgheight = image.size.height
                
                height.constant = cell.frame.width * imgheight / imgwidth
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ZoomCellWithImage
        cell.image.image = UIImage(named: self.images[indexPath.row])
        cell.setContentToCenter()
        cell.scrollView.panGestureRecognizer.addTarget(self, action: #selector(zoomDismissAnim(_:)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

class CellWithImage: UICollectionViewCell, UIScrollViewDelegate
{
    @IBOutlet var image: UIImageView!
}

class ZoomCellWithImage: CellWithImage
{
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageHeightConstraint: NSLayoutConstraint?
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint?
    @IBOutlet var imageTopConstraint: NSLayoutConstraint?
    @IBOutlet var imageBotttomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.image = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.image)
        self.image.contentMode = .scaleAspectFit
        
        self.scrollView.maximumZoomScale = 4
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.image.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageHeightConstraint = Constraint.height(self.image, frame.height)
        self.imageWidthConstraint = Constraint.width(self.image, frame.width)
        self.scrollView.contentSize = frame.size
        
        self.addConstraints(Constraint.stickToSides(self, self.scrollView))
        self.scrollView.addConstraints(Constraint.stickToSides(self.scrollView, self.image))
        self.scrollView.addConstraints([self.imageWidthConstraint!, self.imageHeightConstraint!])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if scrollView != nil
        {
            self.scrollView.delegate = self
            setContentToCenter()
        }
        
        if let image = self.image.image
        {
            self.imageHeightConstraint?.constant = self.frame.width * image.size.height / image.size.width
        }
    }
    
    func setContentToCenter()
    {
        self.layoutIfNeeded()
        if self.frame.height < self.image.frame.height
        {
            scrollView.contentInset.top = 0
        }
        else
        {
            if self.imageHeightConstraint != nil
            {
                self.scrollView.contentInset.top = self.frame.height / 2 - self.imageHeightConstraint!.constant / 2
            }
            else
            {
                self.scrollView.contentInset.top = self.frame.height / 2 - self.image.frame.height / 2
            }
        }
        
        if self.frame.width < self.image.frame.width
        {
            scrollView.contentInset.left = 0
        }
        else
        {
            if self.imageWidthConstraint != nil
            {
                self.scrollView.contentInset.left = self.frame.width / 2 - self.imageWidthConstraint!.constant / 2
            }
            else
            {
                self.scrollView.contentInset.left = self.frame.width / 2 - self.image.frame.width / 2
            }
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
        return self.image//self.inZoomView ? self.image : nil
    }
    
    private var didZoomInsetSet: Bool = false
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        setContentToCenter()
    }
}

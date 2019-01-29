//
//  ViewController.swift
//  photoviewer
//
//  Created by ゲストユーザ on 2018/01/02.
//  Copyright © 2018年 ゲストユーザ. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func splitView(_ sender: Any) {
        if splitNum <= 1 {
            return
        }
        splitNum -= 1
        collectionView.reloadData()
    }
    
    @IBAction func uniteView(_ sender: Any) {
        splitNum += 1
        collectionView.reloadData()
    }
    
    var photos: [PHAsset] = []
    var splitNum: CGFloat = 3
    
    let manager = PHImageManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                self.loadPhotos()
            }
        }
    }
    
    func loadPhotos() {
        let result = PHAsset.fetchAssets(with: .image, options: nil)
        let indexSet = IndexSet(integersIn: 0...result.count - 1)
        let loadedPhotos = result.objects(at: indexSet)
        photos = loadedPhotos
        DispatchQueue.main.sync {
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ImageCell", for: indexPath)
        let asset = photos[indexPath.item]
        let whidh = collectionView.bounds.size.width / 3
        manager.requestImage(
            for: asset,
            targetSize: CGSize(width: whidh, height: whidh),
            contentMode: .aspectFill,
            options: nil,
            resultHandler: { result, info in
                if let image = result {
                    let imageView = cell.viewWithTag(1) as! UIImageView
                    imageView.image = image
                }
            }
        )
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / splitNum
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

}


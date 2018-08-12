
//
//  DisplayEventViewController.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 29/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class DisplayEventViewController: UIViewController, BindableType {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: DisplayEventViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updatingNavigationBarSettings()
    }

    func bindViewModel() {
        //
    }
    
    fileprivate func updatingNavigationBarSettings() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(self.backButtonClicked))
    }
    
    @objc func backButtonClicked() {
        viewModel.sceneCoordinator.pop()
    }
}

extension DisplayEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayEventImageCell", for: indexPath)
        
        let eventImageView = cell.viewWithTag(30) as! UIImageView
        eventImageView.kf.setImage(with: viewModel.event.getImageURL())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height/2)
    }
}

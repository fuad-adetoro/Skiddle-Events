//
//  ViewController.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 29/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class EventsListViewController: UIViewController, BindableType {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: EventsListViewModel!
    
    var events: [Event] = []
    
    private let coordinate: Coordinate = Coordinate(longitude: 0.084387, latitude: 51.494823)
    private var skiddleURL: Observable<String> = Observable.of("https://www.skiddle.com/api/v1/events/search/?api_key=\(apiKey)")
    
    private let eventListViewCellId = "EventListViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureCollectionView()
    }
    
    func bindViewModel() {
        viewModel.data.drive(onNext: { (events) in
            self.events = events
            self.collectionView.reloadData()
        }).disposed(by: self.rx.disposeBag)
        
        skiddleURL.bind(to: viewModel.searchText).disposed(by: self.rx.disposeBag)
        
        viewModel.data.map { "\($0.count) Events" }.drive(navigationItem.rx.title).disposed(by: self.rx.disposeBag)
    }
    
    func configureCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 6
        }
    }
}

extension EventsListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eventListViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: eventListViewCellId, for: indexPath) as! EventListViewCell
        
        eventListViewCell.configure(event: self.events[indexPath.row])
        
        return eventListViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 141)
    }
}


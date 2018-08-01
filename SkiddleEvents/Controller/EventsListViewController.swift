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
import CoreLocation
import RxCoreLocation

class EventsListViewController: UIViewController, BindableType {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noLocationLabel: UILabel!
    
    var viewModel: EventsListViewModel!
    
    var events: [Event] = []
    
    private let coordinate: Coordinate = Coordinate(longitude: 0.084387, latitude: 51.494823)
    private var skiddleURL: Variable<String> = Variable("")
    
    private let eventListViewCellId = "EventListViewCell"
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureCollectionView()
    }
    
    func bindViewModel() {
        viewModel.data.skip(1).drive(onNext: { (events) in
            self.events = events
            
            self.activityIndicator.stopAnimating()
            
            self.collectionView.reloadData()
        }).disposed(by: self.rx.disposeBag)
        
        skiddleURL.asObservable().bind(to: viewModel.searchText).disposed(by: self.rx.disposeBag)
        
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

//Mark: RxCoreLocation extension
extension EventsListViewController {
    func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        didUpdateLocation()
    locationManager.rx.didChangeAuthorization.observeOn(MainScheduler.instance).subscribe(onNext: { (manager, status) in
            switch status {
            case .denied, .notDetermined, .restricted:
                if self.events.count == 0 {
                    self.activityIndicator.stopAnimating()
                    self.noLocationLabel.isHidden = false
                }
            default:
                self.noLocationLabel.isHidden = true
                
                if self.events.count == 0 {
                    self.activityIndicator.startAnimating()
                    self.didUpdateLocation()
                }
            }
        }).disposed(by: self.rx.disposeBag)
    }
    
    func didUpdateLocation() {
        locationManager.rx.didUpdateLocations.take(1).subscribe(onNext:  { (location) in
            let locationCoordinate = location.locations[0].coordinate
            let coordinate = Coordinate(longitude: locationCoordinate.longitude, latitude: locationCoordinate.latitude)
                        
            self.skiddleURL.value = "https://www.skiddle.com/api/v1/events/search/?api_key=\(apiKey)&longitude=\(coordinate.longitude)&latitude=\(coordinate.latitude)&radius=50&limit=50"
        }).disposed(by: self.rx.disposeBag)
    }
}


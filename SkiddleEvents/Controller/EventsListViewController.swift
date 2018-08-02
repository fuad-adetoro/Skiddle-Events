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

class EventsListViewController: UIViewController {
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
    
    func configureCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 6
        }
    }
    
    func openEvent(event: Event) {
        let displayEventViewModel = DisplayEventViewModel(sceneCoordinator: viewModel.sceneCoordinator, event: event)
            
        viewModel.sceneCoordinator.transition(to: Scene.displayEvents(displayEventViewModel), type: .push)
    }
}

extension EventsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 141)
    }
}

//Mark: BindableType Extension
extension EventsListViewController: BindableType {
    func bindViewModel() {
        bindDataToCollectionView()
        
        skiddleURL.asObservable().bind(to: viewModel.searchText).disposed(by: self.rx.disposeBag)
        
        viewModel.data.map { "\($0.count) Events" }.drive(navigationItem.rx.title).disposed(by: self.rx.disposeBag)
        
        collectionViewItemSelected()
    }
    
    func bindDataToCollectionView() {
        let dataObservable = viewModel.data.skip(1).asObservable()
        
        dataObservable.bind(to: collectionView.rx.items(cellIdentifier: eventListViewCellId, cellType: EventListViewCell.self)) { _, event, cell in
            
            cell.configure(event: event)
            
            }.disposed(by: self.rx.disposeBag)
        
        dataObservable.subscribe(onNext: { [weak self] events in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.events = events
            
            strongSelf.activityIndicator.stopAnimating()
        }).disposed(by: self.rx.disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: self.rx.disposeBag)
    }
    
    func collectionViewItemSelected() {
        collectionView.rx.itemSelected.asDriver().debounce(0.3).asObservable().subscribe(onNext: { [weak self] indexPath in
            guard let strongSelf = self else {
                return
            }
            
            let event = strongSelf.events[indexPath.row]
            strongSelf.openEvent(event: event)
        }).disposed(by: self.rx.disposeBag)
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


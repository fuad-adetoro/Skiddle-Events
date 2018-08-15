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
    @IBOutlet weak var refreshButton: UIButton!
    
    var viewModel: EventsListViewModel!
    
    private let events = BehaviorRelay<[Event]>(value: [])
    
    private let skiddleURL = BehaviorRelay<String>(value: "")
    
    private let eventListViewCellId = "EventListViewCell"
    
    private let locationManager = CLLocationManager()
    
    // Error handling variable, CanStopAnimator
    // By default it's true so we can stop the animator and show an error message when the user clicks okay, unless if a network request goes on and we want the animator to be animating.
    private var canStopAnimator = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "0 Events"
        
        configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 6
        }
    }
    
    private func openEvent(_ event: Event) {
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
        _ = RxReachability.shared.startMonitor("skiddle.com")
        
        let eventsData = viewModel.events.observeOn(MainScheduler.instance).skip(1)
        let reachabilityStatus = RxReachability.shared.status.skip(1)
        
        var userOnline = false
        
        refreshButton.rx.tap.throttle(1, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            if !userOnline {
                strongSelf.handleData(eventsData)
                userOnline = true
            } else {
                strongSelf.handleEventData(dataObservable: eventsData)
            }
        }).disposed(by: self.rx.disposeBag)
        
        reachabilityStatus.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] reachable in
            guard let strongSelf = self else {
                return
            }
            
            switch reachable {
            case .online:
                strongSelf.canStopAnimator = false
                
                if !userOnline {
                    userOnline = true
                    
                    strongSelf.handleData(eventsData)
                }
            case .offline, .unknown:
                if !userOnline {
                    strongSelf.displayAlertAction(alertActionStyle: .default, title: nil, message: "Please check your internet connection.")
                    strongSelf.refreshButton.isHidden = false
                    strongSelf.refreshButton.isEnabled = true
                } else {
                    break;
                }
            }
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func handleData(_ eventsData: Observable<[Event]>) {
        // Converting data to driver to make sure bind doesn't result to a fatal error
        self.handleEventData(dataObservable: eventsData)
        
        self.bindDataToCollectionView()
        
        self.skiddleURL.asObservable().bind(to: self.viewModel.searchText).disposed(by: self.rx.disposeBag)
        
        self.collectionViewItemSelected()
    }
    
    private func bindDataToCollectionView() {
        self.events.asDriver().map{ "\($0.count) Events" }.drive(self.navigationItem.rx.title).disposed(by: self.rx.disposeBag)
        
        events.observeOn(MainScheduler.instance).bind(to: collectionView.rx.items(cellIdentifier: eventListViewCellId, cellType: EventListViewCell.self)) { _, event, eventListViewCell in
            eventListViewCell.configure(with: event)
            }.disposed(by: self.rx.disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: self.rx.disposeBag)
    }
    
    private func collectionViewItemSelected() {
        let itemSelelected = collectionView.rx.itemSelected.throttle(1, scheduler: MainScheduler.instance)
        
        itemSelelected.subscribe(onNext: { [weak self] indexPath in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.events.asObservable().enumerated().map({ (index, eventArr) -> Event in
                return eventArr[indexPath.row]
            }).throttle(1, scheduler: MainScheduler.instance).subscribe(onNext: { event in
                strongSelf.openEvent(event)
            }).disposed(by: strongSelf.rx.disposeBag)
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func handleEventData(dataObservable: Observable<[Event]>) {
        self.dismissCurrentAlertController(in: self)
        
        refreshButton.isHidden = true
        refreshButton.isEnabled = false
        
        self.activityIndicator.startAnimating()
        
        dataObservable.subscribe(onNext: { [weak self] events in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.events.accept(events)
            
            strongSelf.activityIndicator.stopAnimating()
        }, onError: { [weak self] e in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.handleError(error: e)
        }).disposed(by: self.rx.disposeBag)
    }
}

//Mark: RxCoreLocation extension
extension EventsListViewController {
    private func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let didChangeAuth = locationManager.rx.didChangeAuthorization.observeOn(MainScheduler.instance).map { manager, status -> Bool in
            switch status {
            case .denied, .notDetermined, .restricted:
                return false
            default:
                return true
            }
            }.asDriver(onErrorJustReturn: true)
        
        didChangeAuth.drive(onNext: { [weak self] authorised in
            guard let strongSelf = self else {
                return
            }
            
            if authorised {
                strongSelf.didUpdateLocation()
            }
            
            strongSelf.noLocationLabel.isHidden = authorised
            }).disposed(by: self.rx.disposeBag)
    }
    
    private func didUpdateLocation() {
        let didUpdateLocation = locationManager.rx.didUpdateLocations.observeOn(MainScheduler.instance)
        didUpdateLocation.take(1).subscribe(onNext: { [weak self] location in
            guard let strongSelf = self else {
                return
            }
            
            let locationCoordinate = location.locations[0].coordinate
            let coordinate = Coordinate(longitude: locationCoordinate.longitude, latitude: locationCoordinate.latitude)
            
            let apiKey = try? SkiddleAPI.shared.apiKey.value()
            
            let eventURL = "https://www.skiddle.com/api/v1/events/search/?api_key=\(apiKey!)&longitude=\(coordinate.longitude)&latitude=\(coordinate.latitude)&radius=50&limit=50"
            strongSelf.skiddleURL.accept(eventURL)
        }).disposed(by: self.rx.disposeBag)
    }
}

//Mark: Error handling
extension EventsListViewController {
    private func handleError(error e: Error) {
        refreshButton.isHidden = false
        refreshButton.isEnabled = true
        
        if let e = e as? RxURLSessionError {
            displayAlertAction(alertActionStyle: .default, title: nil, message: e.errorDescription)
        } else if (e as NSError).code == -1009 {
            displayAlertAction(alertActionStyle: .default, title: nil, message: "Please check your internet connection.")
        } else {
            displayAlertAction(alertActionStyle: .default, title: nil, message: "An error has occurred.")
        }
    }
}

//Mark: DisplayAlertAction
extension EventsListViewController {
    private func displayAlertAction(alertActionStyle: UIAlertActionStyle, title: String?, message: String?) {
        let alertController = self.displayAlertController(with: "OK", using: alertActionStyle, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            if strongSelf.canStopAnimator {
                strongSelf.activityIndicator.stopAnimating()
            }
            }, controllerTitle: title, controllerMessage: message)
        
        // Checking if an alertController is already being displayed, if so then it dismisses the previous one and present the new one
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

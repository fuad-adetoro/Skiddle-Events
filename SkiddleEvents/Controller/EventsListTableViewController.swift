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

class EventsListTableViewController: UITableViewController, BindableType {
    var viewModel: EventsListViewModel!
    
    var events: [Event] = []
    
    private let coordinate: Coordinate = Coordinate(longitude: 0.084387, latitude: 51.494823)
    private var skiddleURL: Observable<String> = Observable.of("https://www.skiddle.com/api/v1/events/search/?api_key=\(apiKey)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 155
    }
    
    func bindViewModel() {
        viewModel.data.drive(onNext: { (events) in
            self.events = events
            self.tableView.reloadData()
        }).disposed(by: self.rx.disposeBag)
        
        skiddleURL.bind(to: viewModel.searchText).disposed(by: self.rx.disposeBag)
        
        viewModel.data.map { "\($0.count) Events" }.drive(navigationItem.rx.title).disposed(by: self.rx.disposeBag)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListViewCell") as! EventListViewCell
        
        cell.configure(event: self.events[indexPath.row])
        
        return cell
    }
}


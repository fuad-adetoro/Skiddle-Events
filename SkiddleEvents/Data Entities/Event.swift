//
//  Event.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 29/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation
import Unbox

typealias EventLocation = (postCode: String, town: String, address: String, venueName: String, longitude: Double, latitude: Double, venueId: String)

class Event {
    @objc dynamic var title: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var smallImageURL: String? = nil
    @objc dynamic var largeImageURL: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var startDate: String? = nil
    @objc dynamic var endDate: String? = nil
    @objc dynamic var description: String = ""
    var eventLocation: EventLocation!
    @objc dynamic var entryPrice: String = ""
    var artists: [Artist] = []
    
    init(event: Event) {
        title = event.title
        id = event.id
        url = event.url
        smallImageURL = event.smallImageURL
        largeImageURL = event.largeImageURL
        date = event.date
        startDate = event.startDate
        endDate = event.endDate
        description = event.description
        eventLocation = event.eventLocation
        entryPrice = event.entryPrice
        artists = event.artists
    }
    
    init() {}
}

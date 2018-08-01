//
//  Event.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 29/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

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

extension Event {
    func getFullAddress() -> String {
        let address = self.eventLocation!.address
        
        var fullAddress = address
        
        if !address.contains(self.eventLocation!.town) {
            fullAddress = fullAddress + ", \(self.eventLocation!.town)"
        }
        
        if !address.contains(self.eventLocation!.postCode) {
            fullAddress = fullAddress + ", \(self.eventLocation!.postCode)"
        }
        
        // Sometimes the address is returned with a space in front of it.
        var addressReference = fullAddress
        let space = addressReference.removeFirst().description
        
        if space.contains(" ") {
            fullAddress.remove(at: fullAddress.startIndex)
        }
        
        return fullAddress
    }
    
    func getVenueName() -> String {
        let eventLocation = self.eventLocation!
        
        return "@\(eventLocation.venueName)"
    }
    
    func getEventDate() -> String {
        let dateOrganiseArray = self.date.components(separatedBy: "-")
        let year = dateOrganiseArray[0]
        let month = dateOrganiseArray[1]
        let day = dateOrganiseArray[2]
        
        var dateComponent = DateComponents()
        dateComponent.year = Int(year)
        dateComponent.month = Int(month)
        dateComponent.day = Int(day)
        
        let eventDate = Calendar.current.date(from: dateComponent)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        let dateString = formatter.string(from: eventDate!)
        
        guard let endDate = endDate else {
            return dateString
        }
        
        let stringIndex = endDate.index(endDate.startIndex, offsetBy: 10)
        let newEndDate = String(endDate.prefix(upTo: stringIndex))
        
        let endDateOrganiseArray = newEndDate.components(separatedBy: "-")
        let endYear = endDateOrganiseArray[0]
        let endMonth = endDateOrganiseArray[1]
        let endDay = endDateOrganiseArray[2]
        
        var endDateComponent = DateComponents()
        endDateComponent.year = Int(endYear)
        endDateComponent.month = Int(endMonth)
        endDateComponent.day = Int(endDay)
        
        let endEventDate = Calendar.current.date(from: endDateComponent)
        let endDateString = formatter.string(from: endEventDate!)
        
        if endDateString == dateString {
            return dateString
        } else {
            return "\(dateString) - \(endDateString)"
        }
    }
}

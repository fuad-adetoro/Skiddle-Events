//
//  SkiddleAPI.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 29/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation

import RxSwift
import SwiftyJSON
import RxAlamofire

public let apiKey = "4787266f998deabb86c710474f41cc20"

typealias Coordinate = (longitude: Double, latitude: Double)

enum SkiddleAPIError: Error {
    case eventNotFound
    case serverFailure
    case invalidKey
}

protocol SkiddleAPIType {
    func events(from json: JSON) -> [Event]
}

class SkiddleAPI: SkiddleAPIType {
    public static let shared = SkiddleAPI()
    
    let disposeBag = DisposeBag()
    
    func events(from json: JSON) -> [Event] {
        var events: [Event] = []
        
        for sectionData in json.array! {
            var appendEvent = true
            
            let event = Event()
            
            let eventID = sectionData["id"].stringValue
            
            event.id = eventID
            
            var eventTitle = sectionData["eventname"].stringValue
            eventTitle = eventTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            event.title = eventTitle.decodeHTMLString
            
            event.smallImageURL = sectionData["imageurl"].string
            event.largeImageURL = sectionData["largeimageurl"].stringValue
            event.url = sectionData["link"].stringValue + "?skrep=2465567&sktag=14567&skcampaign=DowntownApp"
            
            var description = sectionData["description"].stringValue
            description = description.trimmingCharacters(in: .whitespacesAndNewlines)
            description = description.decodeHTMLString
            
            event.description = description
            
            event.date = sectionData["date"].stringValue.decodeHTMLString
            event.startDate = sectionData["startdate"].string
            event.endDate = sectionData["enddate"].string
            
            if let entryPrice = sectionData["entryprice"].string {
                var newEntryPrice = entryPrice
                if newEntryPrice.lowercased().contains("free entry: ") {
                    newEntryPrice = newEntryPrice.replacingOccurrences(of: "FREE ENTRY: ", with: "")
                }
                
                event.entryPrice = newEntryPrice
            }
            
            // Event Location
            let venueInfo = sectionData["venue"]
            let locationFromEvent = self.locationFromEvent(venueInfo: venueInfo)
            
            if !locationFromEvent.canContinue {
                continue
            }
            
            event.eventLocation = locationFromEvent.eventLocation!
            
            // Event Artist
            let artistsInfo = sectionData["artists"]
            event.artists = self.artistsFromEvent(artistsInfo: artistsInfo)
            
            for eventRef in events {
                if event.id == eventRef.id {
                    appendEvent = false
                } else if event.url == eventRef.url {
                    appendEvent = false
                } else if event.title == eventRef.title && event.getEventDate() == eventRef.getEventDate() {
                    appendEvent = false
                }
            }
            
            if appendEvent {
                events.append(event)
            }
        }
        
        return events
    }
    
    func locationFromEvent(venueInfo: JSON) -> (canContinue: Bool, eventLocation: EventLocation?) {
        let address = venueInfo["address"].stringValue.decodeHTMLString
        let postcode = venueInfo["postcode"].stringValue.decodeHTMLString
        let town = venueInfo["town"].stringValue.decodeHTMLString
        let venueName = venueInfo["name"].stringValue.decodeHTMLString
        let longitudeString = venueInfo["longitude"].stringValue
        let latitudeString = venueInfo["latitude"].stringValue
        let venueId = venueInfo["id"].stringValue
        
        if let longitude = Double(longitudeString), let latitude = Double(latitudeString) {
            let eventLocation = EventLocation(postCode: postcode, town: town, address: address, venueName: venueName, longitude: longitude, latitude: latitude, venueId: venueId)
            return (true, eventLocation)
        } else {
            return (false, nil)
        }
    }
    
    func artistsFromEvent(artistsInfo: JSON) -> [Artist] {
        var artists: [Artist] = []
        
        if let artistsArray = artistsInfo.array {
            for artist in artistsArray {
                var appendArtist = true
                
                let currentArtist = Artist()
               
                let name = artist["name"].stringValue
                let id = artist["artistid"].stringValue
                let spotifyUniqueId = artist["spotifyartisturl"].string
                
                currentArtist.name = name
                currentArtist.id = id
                currentArtist.imageURL = artist["image"].stringValue
                currentArtist.spotifyMP3URL = artist["spotifymp3url"].string
                currentArtist.spotifyUniqueId = spotifyUniqueId
                
                for a in artists {
                    if a.name == name || a.spotifyUniqueId == spotifyUniqueId || a.id == id {
                        appendArtist = false
                    }
                }
                
                if appendArtist && spotifyUniqueId != nil {
                    artists.append(currentArtist)
                }
            }
        }
        
        return artists
    }
}

//
//  Artist.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 29/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation
import RxDataSources

class Artist {
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var spotifyMP3URL: String? = nil
    @objc dynamic var spotifyUniqueId: String? = nil
    
    init(artist: Artist) {
        name = artist.name
        id = artist.id
        imageURL = artist.imageURL
        spotifyMP3URL = artist.spotifyMP3URL
        spotifyUniqueId = artist.spotifyUniqueId
    }
    
    init() {}
}

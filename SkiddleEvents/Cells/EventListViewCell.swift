//
//  EventListViewCell.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 30/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit
import Kingfisher

class EventListViewCell: UICollectionViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var venueLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        eventImageView.image = nil
        titleLabel.text = nil
        venueLocationLabel.text = nil
        eventDateLabel.text = nil
        eventLocationLabel.text = nil
    }
    
    func configure(with event: Event) {
        self.titleLabel.text = event.title
        
        eventImageView.kf.setImage(with: URL(string: event.largeImageURL)!)
        
        eventLocationLabel.text = event.getFullAddress()
        
        venueLocationLabel.text = event.getVenueName()
        
        eventDateLabel.text = event.getEventDate()
    }

}

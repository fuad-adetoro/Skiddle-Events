//
//  EventListViewCell.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 30/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit
import Kingfisher

class EventListViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(event: Event) {
        self.titleLabel.text = event.title
        
        if let smallImageURLString = event.smallImageURL {
            let smallImageURL = URL(string: smallImageURLString)!
            eventImageView.kf.setImage(with: smallImageURL)
        } else {
            eventImageView.kf.setImage(with: URL(string: event.largeImageURL)!)
        }
    }

}

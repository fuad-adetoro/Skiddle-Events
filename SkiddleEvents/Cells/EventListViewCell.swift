//
//  EventListViewCell.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 30/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

class EventListViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(event: Event) {
        
    }

}

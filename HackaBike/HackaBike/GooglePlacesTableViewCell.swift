//
//  GooglePlacesTableViewCell.swift
//  HackaBike
//
//  Created by Paulo Henrique Leite on 16/04/16.
//  Copyright © 2016 Paulo Henrique Leite. All rights reserved.
//

import UIKit

class GooglePlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var favorite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

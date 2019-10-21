//
//  WordListTableViewCell.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-04.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WordListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var genderIndicatorView: UIView!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var correctLabel: UILabel!
    
    @IBOutlet weak var incorrectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

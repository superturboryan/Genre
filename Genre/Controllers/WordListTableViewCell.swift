//
//  WordListTableViewCell.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-04.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WordListTableViewCell: UITableViewCell {
    
    var word: Word = Word()
    
    @IBOutlet weak var genderIndicatorView: UIView!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var correctLabel: UILabel!
    
    @IBOutlet weak var incorrectLabel: UILabel!
    
    @IBOutlet var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func favouritePressed(_ sender: Any) {
        WordManager.sharedInstance.set(word: self.word, favourite: !self.word.favourite)
        self.word = WordManager.sharedInstance.getWordFor(string: self.word.word!)!
        
        updateStar()
    }
    
    func updateStar() {
        if #available(iOS 13.0, *) {
            self.favouriteButton.setBackgroundImage(UIImage(systemName: self.word.favourite ? "star.fill" : "star"), for: .normal)
        } else {
            return
        }
    }
    
}

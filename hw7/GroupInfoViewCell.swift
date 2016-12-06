//
//  groupInfoViewCell.swift
//  Project4_Animation
//
//  Created by Yuchen Zhou on 10/15/16.
//  Copyright © 2016 Yuchen Zhou. All rights reserved.
//
//  Cell for Group Members, containing outlet for the edit button

import UIKit

// Cell Class for Team Member
class GroupInfoViewCell: UITableViewCell {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellNetID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

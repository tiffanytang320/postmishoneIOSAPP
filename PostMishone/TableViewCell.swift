//
//  TableViewCell.swift
//  PostMishone
//
//  Created by Victor Liang on 2018-11-21.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var missionImage: UIImageView!
    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var missionDescription: UILabel!
    @IBOutlet weak var missionReward: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  TimeOffTypeTableViewCell.swift
//  PathmazingVIP
//
//  Created by Samrith Yoeun on 7/9/19.
//  Copyright © 2019 Pathmazing. All rights reserved.
//

import UIKit

class TimeOffTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var timeOffTypeLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
        if selected {
            self.tickImageView.isHidden = false
            self.timeOffTypeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            
        } else {
            self.tickImageView.isHidden = true
            self.timeOffTypeLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
    }
    
}

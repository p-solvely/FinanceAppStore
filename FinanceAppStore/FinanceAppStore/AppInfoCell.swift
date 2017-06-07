//
//  AppIntoCell.swift
//  FinanceAppStore
//
//  Created by sol on 2017. 6. 6..
//  Copyright © 2017년 sol. All rights reserved.
//

import UIKit

class AppInfoCell: UITableViewCell {
    
    @IBOutlet var rankingLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 20
        icon.layer.borderColor = UIColor.lightGray.cgColor
        icon.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

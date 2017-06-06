//
//  AppIntoCell.swift
//  FinanceAppStore
//
//  Created by sol on 2017. 6. 6..
//  Copyright © 2017년 sol. All rights reserved.
//

import UIKit

class AppIntoCell: UITableViewCell {
    
    @IBOutlet var rankingLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//
//  LanguageTableViewCell.swift
//  GitHubExplorer
//
//  Created by Raul Silva on 3/24/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var languageLable: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

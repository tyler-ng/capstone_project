//
//  GeneralInforCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-15.
//

import UIKit

class WebsiteURLCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var websiteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        websiteLabel.text = ""
    }
}

//
//  RiskFactorCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-08.
//

import UIKit

class RiskFactorCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.backgroundColor = .systemYellow
//        descriptionLabel.isHidden = true
        descriptionLabelHeight?.constant = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

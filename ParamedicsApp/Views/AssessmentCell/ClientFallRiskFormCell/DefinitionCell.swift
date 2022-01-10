//
//  DefinitionCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-08.
//

import UIKit

class DefinitionCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var circleValueLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
        
    @IBOutlet weak var radioImageView: UIImageView!
    
    var questionId: Int?
    var indexPathForMainCell: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circleValueLabel.textColor = .systemRed
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


//
//  YesNoChoiceCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-17.
//

import UIKit

class LabelAndCheckRadioCell: UITableViewCell {
    @IBOutlet weak var answerChoiceLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellHeight?.constant = CGFloat(LayoutConstraints.labelAndCheckRadioCellHeight)
    }
}

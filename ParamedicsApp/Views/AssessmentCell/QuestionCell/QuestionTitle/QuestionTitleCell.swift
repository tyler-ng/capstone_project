//
//  QuestionTitleCell.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-30.
//

import UIKit

class QuestionTitleCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var TitleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TitleLb.text = ""
        mainView.backgroundColor = .systemYellow
    }
}

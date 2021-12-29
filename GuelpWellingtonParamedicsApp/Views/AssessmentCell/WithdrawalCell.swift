//
//  WithdrawCell2.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-13.
//

import UIKit

class WithdrawalCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
    
    }
}

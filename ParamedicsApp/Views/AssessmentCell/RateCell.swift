//
//  RateCell.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-13.
//

import UIKit
import VerticalSteppedSlider

protocol RateCellProtocol: AnyObject {
    func getSelectedLevel(level: String, questionId: Int)
}

class RateCell: UITableViewCell {
    @IBOutlet weak var vsslider: VSSlider!
    
    @IBOutlet weak var levelValue: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var questionId: Int?
    
    var delegate: RateCellProtocol?
    
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        let selectedLevel = String(format: "%.0f", vsslider.roundedValue)
        levelValue.text = selectedLevel
        if let questionId = questionId {
            delegate?.getSelectedLevel(level: selectedLevel, questionId: questionId)
        }
    }
}

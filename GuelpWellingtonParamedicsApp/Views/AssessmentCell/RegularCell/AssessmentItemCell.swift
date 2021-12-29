//
//  AssessmentItemCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-12.
//

import UIKit
import SkeletonView

class AssessmentItemCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
    }
    
    func showAnimation() {
        mainView.isSkeletonable = true
        mainView.showAnimatedGradientSkeleton()
    }
    
    func stopAnimation() {
        mainView.hideSkeleton()
    }
}

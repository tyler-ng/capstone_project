//
//  RateView.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-13.
//

import UIKit

protocol RateViewDelegate: AnyObject {
    func getRateFromCell(_ rate: String, _ questionId: Int, _ rateView: RateView)
}

class RateView: UIView {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var radioIconImage: UIImageView!
    
    @IBOutlet weak var hyphenLabel: UILabel!
    
    var delegate: RateViewDelegate?
    
    public var rate: String?
    public var questionId: Int?
    public var isSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rateViewWasTapped(sender:)))
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(tap)
    }
    
    @objc func rateViewWasTapped(sender: UITapGestureRecognizer) {
        guard let rate = rate, let questionId = questionId else {
            return
        }
        isSelected = true
        delegate?.getRateFromCell(rate, questionId, self)
    }
}

class MyClass: UIView {
    class func instanceFromNib(nibView: String) -> UIView {
        return UINib(nibName: nibView, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

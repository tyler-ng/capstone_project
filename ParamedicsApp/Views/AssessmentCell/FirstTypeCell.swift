//
//  FirstTypeCell.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-17.
//

import UIKit

protocol CellDelegate: AnyObject {
    func getScoreValue(score: String, questionId: Int, indexPath: IndexPath)
}

class FirstTypeCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scoreTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var questionId: Int?
    
    var indexPath: IndexPath?
    
    var scores = ["Select score"]
    
    var delegate: CellDelegate?
    
    public var max_score: Int? {
        didSet {
            if let max_score = max_score, scores.count == 1 {
                for i in 0...max_score {
                    scores.append("\(i)")
                }
            }
        }
    }
    
    let pickerView = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        scoreTextField.textAlignment = .center

        scoreTextField.attributedPlaceholder = NSAttributedString(string: "Select score", attributes: [
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        self.scoreTextField.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return scores[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedText = scores[row]
        if selectedText == "Select score" {
            scoreTextField.text = nil
        } else {
            let selectedScore = scores[row]
            scoreTextField.text = selectedScore
            if let id = self.questionId, let indexPath = indexPath {
                delegate?.getScoreValue(score: selectedScore, questionId: id, indexPath: indexPath)
            }
        }
        scoreTextField.resignFirstResponder()
    }
}


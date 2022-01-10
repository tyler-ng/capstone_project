//
//  SecondTypeCell.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-17.
//

import UIKit

class SecondTypeCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var title1: UILabel!
    
    @IBOutlet weak var title2: UILabel!
    
    @IBOutlet weak var title3: UILabel!
    
    @IBOutlet weak var title4: UILabel!
    
    @IBOutlet weak var scoreTextField: UITextField!
    
    @IBOutlet weak var trialTextField: UITextField! {
        didSet {
            trialTextField?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    
    var pickerView = UIPickerView()
    
    var questionId: Int?
    
    var indexPath: IndexPath?
    
    var scores = ["Select score"]
    
    var delegate: CellDelegate?
    
    public var max_score: Int? {
        didSet {
            if let max_score = max_score {
                for i in 0...max_score {
                    scores.append("\(i)")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // temperature init value for IBOutlet
        title1.text = "Name of 3 common object (e.g., \"apple,\" \"table,\" \"penny\"):"
        title2.text = "Take one second to say each. Then ask the patient to repeat all 3 after you have said them. (Give one point for each correct answer.)"
        title3.text = "If score is less than 3/3, repeat the task (to a maximum of 6 times). Record how many trials it took to obtain 3/3."
        title4.text = "# of Trials:"
        
        trialTextField.attributedPlaceholder = NSAttributedString(string: "Enter number of trials", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        
        scoreTextField.attributedPlaceholder = NSAttributedString(string: "Select score", attributes: [
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        pickerView.delegate = self
        pickerView.dataSource = self
        scoreTextField.inputView = pickerView
    }
    
    @objc func doneButtonTappedForMyNumericTextField() {
        trialTextField.resignFirstResponder()
    }
}

extension SecondTypeCell: UIPickerViewDelegate, UIPickerViewDataSource {
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
            if let id = self.questionId, let indexPath = self.indexPath {
                delegate?.getScoreValue(score: selectedScore, questionId: id, indexPath: indexPath)
            }
        }
        scoreTextField.resignFirstResponder()
    }
}

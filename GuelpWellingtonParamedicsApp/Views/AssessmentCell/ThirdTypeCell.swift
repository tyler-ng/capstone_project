//
//  ThirthTypeCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-17.
//

import UIKit

class ThirdTypeCell: UITableViewCell {
    
    @IBOutlet weak var title1: UILabel!
    
    @IBOutlet weak var title2: UILabel!
    
    @IBOutlet weak var scoreTextField: UITextField!
    
    @IBOutlet weak var order1TextField: UITextField!
    
    @IBOutlet weak var order2TextField: UITextField!
    
    @IBOutlet weak var order3TextField: UITextField!
    
    @IBOutlet weak var order4TextField: UITextField!
    
    @IBOutlet weak var order5TextField: UITextField!
    
    var activeTextField = UITextField()
    
    let pickView = UIPickerView()
    let pickView2 = UIPickerView()
    
    var questionId: Int?
    
    var indexPath: IndexPath?
    
    var delegate: CellDelegate?
    
    var scores = ["Select score"]
    
    var rowForPickView2 = ["1", "2", "3", "4", "5"]
    
    public var max_score: Int? {
        didSet {
            if let max_score = max_score {
                scores = ["Select score"]
                for i in 0...max_score {
                    scores.append("\(i)")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title1.text = "Spell \"world\" backwards. The score is the number of lengths in correct order."
        title2.text = "Skipped letters are ignored i.e."
        
        scoreTextField.attributedPlaceholder = NSAttributedString(string: "Select score", attributes: [
            .font: UIFont.systemFont(ofSize: 12)
        ])
        
        pickView.delegate = self
        pickView.dataSource = self
        
        pickView2.delegate = self
        pickView2.dataSource = self
        
        scoreTextField.inputView = pickView
        order1TextField.inputView = pickView2
        order2TextField.inputView = pickView2
        order3TextField.inputView = pickView2
        order4TextField.inputView = pickView2
        order5TextField.inputView = pickView2
        
        order1TextField.delegate = self
        order2TextField.delegate = self
        order3TextField.delegate = self
        order4TextField.delegate = self
        order5TextField.delegate = self
    }
}

extension ThirdTypeCell: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickView {
            return scores.count
        } else {
            return rowForPickView2.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickView {
            return scores[row]
        } else {
            return rowForPickView2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickView {
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
        } else if pickerView == pickView2 {
            let selectedOrder = rowForPickView2[row]
            self.activeTextField.text = selectedOrder
            self.activeTextField.resignFirstResponder()
        }
        
    }
}

//
//  FormMetadataCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-17.
//

import UIKit

protocol FormMetadataCellDelegate: AnyObject {
    func passingPatientIdToParentVC(_ text: String, _ cell: LabelAndInputCell)
}

class FormMetadataCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    weak var delegate: FormMetadataCellDelegate?
    
    public var data: [FormMetaData]? {
        didSet {
            myTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        mainView.backgroundColor = .systemGray3
        
        myTableView.register(UINib(nibName: "LabelAndInputCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.labelAndInputCell.rawValue)
        
        myTableView.layer.cornerRadius = 5
        myTableView.layer.masksToBounds = true
        myTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.labelAndInputCell.rawValue, for: indexPath) as! LabelAndInputCell
        cell.selectionStyle = .none
        guard let data = data else { return cell }
        cell.inputTextField.isEnabled = false
        cell.titleLabel.text = data[indexPath.row].title
        if indexPath.row == 2 {
            if let date = data[indexPath.row].value {
                cell.inputTextField.text = DateTimeUtilities.dateFormatter(inputDate: date)
            }
        } else {
            cell.inputTextField.text = data[indexPath.row].value
        }
        
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.inputTextField.placeholder = "Enter 6 digits number"
            cell.inputTextField.isEnabled = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       
    }
}

extension FormMetadataCell: LabelAndInputCellDelegate {
    func passingPatientIdToParentView(_ text: String, cell: LabelAndInputCell) {
        delegate?.passingPatientIdToParentVC(text, cell)
    }
    

}

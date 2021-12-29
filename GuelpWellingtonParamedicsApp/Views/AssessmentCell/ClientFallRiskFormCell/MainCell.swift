//
//  MainCell.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-08.
//

import UIKit

protocol MainCellDelegate: AnyObject {
    func getCircleValueFromCell(value: String, questionId: Int, indexPathForMainCell: IndexPath)
}

class MainCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var indexPathForCell: IndexPath?
    
    var delegate: MainCellDelegate?
    
    public var data: Question? {
        didSet {
            myTableView.reloadData()
            myTableView.layoutIfNeeded()
            myTableView.beginUpdates()
            myTableView.endUpdates()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        mainView.backgroundColor = .systemGray3
        
        cellsRegister()
        
        myTableView.layer.cornerRadius = 5
        myTableView.layer.masksToBounds = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            myTableView.estimatedRowHeight = 90
        } else {
            // Not iPad
            myTableView.estimatedRowHeight = 120
            myTableView.isScrollEnabled = true
        }
        myTableView.rowHeight = UITableView.automaticDimension
        
        
    }
    
    func cellsRegister() {
        self.myTableView.register(UINib(nibName: "DefinitionCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.definitionCell.rawValue)
        self.myTableView.register(UINib(nibName: "RiskFactorCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.riskFactorCell.rawValue)
    }
    
}


extension MainCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = data?.content.items.count {
            return count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.riskFactorCell.rawValue, for: indexPath) as! RiskFactorCell
            guard let data = data else {
                return cell
            }
            cell.titleLabel.text = data.title
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.definitionCell.rawValue, for: indexPath) as! DefinitionCell
            guard let question = data else {
                return cell

            }
            let items = question.content.items
            let item = items[indexPath.row - 1]
            
            cell.descriptionLabel.text = item.description
            cell.circleValueLabel.text = "\(item.value)"
            cell.questionId = question.id
            cell.indexPathForMainCell = self.indexPathForCell
            
            if indexPath.row == items.count {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            // set radio check box on/off
            if let answer = question.answer, Int(answer) == item.value {
                cell.radioImageView.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                cell.radioImageView.image = UIImage(systemName: "circle")
            }
            
            
            
            return cell
        }
    }
}


extension MainCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableViewHeightConstraint?.constant = myTableView.contentSize.height
        
        cell.layoutIfNeeded()
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tappedCell = tableView.cellForRow(at: indexPath) as? DefinitionCell {
            if let circleValue =  tappedCell.circleValueLabel.text,
               let questionId = tappedCell.questionId,
               let indexPath = self.indexPathForCell
            {
                delegate?.getCircleValueFromCell(value: circleValue, questionId: questionId, indexPathForMainCell: indexPath)
            }
        }
    }
    
   
}


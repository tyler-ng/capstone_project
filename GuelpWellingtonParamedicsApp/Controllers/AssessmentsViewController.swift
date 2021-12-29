//
//  AssessementListViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-12.
//

import UIKit

class AssessmentsViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var assessmentForms: [FormModel]?
    var userFullName: String?
    var token: String?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        tableViewCellRegister()
        
        self.title = "Assessments"
    }
    
    func tableViewCellRegister() {
        self.myTableView.register(UINib(nibName: "AssessmentItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.assessmentItemCell.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let selectedIndexPath = selectedIndexPath else {
            return
        }
        let cell = myTableView.cellForRow(at: selectedIndexPath) as! AssessmentItemCell
        cell.mainView.backgroundColor = .clear
        myTableView.reloadRows(at: [selectedIndexPath], with: .none)

    }
    
}

extension AssessmentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AssessmentItemCell
        cell.mainView.backgroundColor = .systemGray6
        selectedIndexPath = indexPath
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.row == 0 {
            let destinationVC = storyboard.instantiateViewController(identifier: viewIdentifiers.mobilityTUGVC.rawValue) as! MobilityTUGViewController
            let form = self.assessmentForms![indexPath.row]
            
            destinationVC.form = form
            destinationVC.userFullName = userFullName
            destinationVC.token = token
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        } else if indexPath.row == 1 {
            let destinationVC = storyboard.instantiateViewController(identifier: viewIdentifiers.clientRiskFallVC.rawValue) as! ClientFallRiskViewController
            let form = self.assessmentForms![indexPath.row]
            
            destinationVC.form = form
            destinationVC.userFullName = userFullName
            destinationVC.token = token
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        } else if indexPath.row == 2 {
            let destinationVC = storyboard.instantiateViewController(withIdentifier: viewIdentifiers.alcoholWithdrawalVC.rawValue) as! AlcoholWithdrawalViewController
            let form = self.assessmentForms![indexPath.row]
            
            destinationVC.form = form
            destinationVC.userFullName = userFullName
            destinationVC.token = token
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        } else if indexPath.row == 3 {
            let destinationVC = storyboard.instantiateViewController(withIdentifier: viewIdentifiers.edmontonSymptonVC.rawValue) as! EdmontonSymptonViewController
            let form = self.assessmentForms![indexPath.row]
            
            destinationVC.form = form
            destinationVC.userFullName = userFullName
            destinationVC.token = token
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
        } else if indexPath.row == 4 {
            let destinationVC = storyboard.instantiateViewController(withIdentifier: viewIdentifiers.miniMentalStateVC.rawValue) as! MiniMentalStateViewController
            let form = self.assessmentForms![indexPath.row]
            
            destinationVC.form = form
            destinationVC.userFullName = userFullName
            destinationVC.token = token
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}

extension AssessmentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assessmentForms?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.assessmentItemCell.rawValue, for: indexPath) as! AssessmentItemCell
        cell.selectionStyle = .none
        guard let assessmentForms = assessmentForms else {
            return cell
        }
        cell.titleLabel.text = assessmentForms[indexPath.row].title
        
        return cell
    }
    
    
}

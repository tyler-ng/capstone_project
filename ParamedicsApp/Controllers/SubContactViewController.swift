//
//  SubContactViewController.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-28.
//

import UIKit

class SubContactViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var department: Department?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = department?.name
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        
        tableViewCellRegister()
    }
    
    func tableViewCellRegister() {
        self.myTableView.register(UINib(nibName: "AssessmentItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.assessmentItemCell.rawValue)
    }
}

extension SubContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return department?.contacts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.assessmentItemCell.rawValue, for: indexPath) as! AssessmentItemCell
        
        guard let department = department else { return cell }
        cell.selectionStyle = .none
        cell.titleLabel.text = department.contacts[indexPath.row].person
        
        return cell
    }
    
    
}


extension SubContactViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let department = department else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: viewIdentifiers.contactDetailsVC.rawValue) as! ContactDetailsViewController

        destinationVC.contact = department.contacts[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

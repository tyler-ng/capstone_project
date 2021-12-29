//
//  ContactsViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-07.
//

import UIKit
import SideMenu

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    private let viewModel = ViewModel()
    private var error: OpenNewError?
    private var departments: [Department]?
    private var communityParamedicsCallNo = "1 866-637-5646"
    private var selectedIndexPath: IndexPath?
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departments = ContactUtilities.initialStaticData()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // for the side menu
        MenuUtilities.initMenu(self: self, menu: menu)
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        
        tableViewCellRegister()
        
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
    
    func tableViewCellRegister() {
        self.myTableView.register(UINib(nibName: "AssessmentItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.assessmentItemCell.rawValue)
    }
    
    
    @IBAction func menuWasTapped(_ sender: Any) {
        present(menu!, animated: true)
    }
    
}

extension ContactsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.assessmentItemCell.rawValue, for: indexPath) as! AssessmentItemCell
        cell.selectionStyle = .none
        
        guard let departments = self.departments else { return cell }
        let department = departments[indexPath.row]
        cell.titleLabel.text = department.name
        
        return cell
    }
    
}


extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AssessmentItemCell
        cell.mainView.backgroundColor = .systemGray6
        selectedIndexPath = indexPath
        
        guard let department = departments?[indexPath.row] else { return } 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: viewIdentifiers.subContactVC.rawValue) as! SubContactViewController

        destinationVC.department = department
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

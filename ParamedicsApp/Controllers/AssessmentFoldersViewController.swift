//
//  AssessmentsViewController.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-07.
//

import UIKit
import SideMenu

class AssessementFoldersViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!

    private let viewModel = ViewModel()
    private var error: OpenNewError?
    private var assessmentFolders: [AssessmentFolderModel]?
    private var userProfile: UserProfile?
    private var selectedIndexPath: IndexPath?
    var menu: SideMenuNavigationController?
    var token: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load token from key chain
        guard let receiveTokenData = KeyChain.load(key: "token") else {
            return
        }
        
        guard let token = String(data: receiveTokenData, encoding: .utf8) else {
            return
        }
        
        self.token = token
        
        // initialize data from assessment forms
        viewModel.initialDataFetching(token)
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // for the side menu
        MenuUtilities.initMenu(self: self, menu: menu)
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        
        tableViewCellRegister()
        
        // updating data from view model
        viewModel.errorStore.bind { [weak self] error in
            guard let error = error else { return }
            self?.error = error
        }
        
        viewModel.assessFoldersStore.bind { [weak self] assessmentFolders in
            guard let assesssmentFolders = assessmentFolders else { return }
            self?.assessmentFolders = assesssmentFolders
            self?.myTableView.reloadData()
        }
        
        viewModel.userProfileStore.bind { [weak self] userProfile in
            guard let userProfile = userProfile else {
                return
            }

            self?.userProfile = userProfile
            self?.myTableView.reloadData()
        }
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
        self.myTableView.register(UINib(nibName: "AssessmentItemCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.assessmentFolderItemCell.rawValue)
    }
    
    @IBAction func menuWasTapped(_ sender: Any) {
        present(menu!, animated: true)
    }
    
}

extension AssessementFoldersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? AssessmentItemCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: viewIdentifiers.assessmentsVC.rawValue) as! AssessmentsViewController
        guard
            let cell = cell,
            let assessmentFolders = assessmentFolders,
            let userProfile = userProfile,
            let token = token
        else {
            return
        }
        selectedIndexPath = indexPath
        cell.mainView.backgroundColor = UIColor.systemGray6
        
        destinationVC.userFullName = userProfile.fullName()
        destinationVC.token = token
        destinationVC.assessmentForms = assessmentFolders[indexPath.row].forms
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension AssessementFoldersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assessmentFolders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.assessmentFolderItemCell.rawValue, for: indexPath) as! AssessmentItemCell
        cell.selectionStyle = .none
        
        guard let assessmentFolders = assessmentFolders else { return cell }
        let aFolder = assessmentFolders[indexPath.row]
        cell.titleLabel.text = aFolder.title
        
        return cell
    }
}

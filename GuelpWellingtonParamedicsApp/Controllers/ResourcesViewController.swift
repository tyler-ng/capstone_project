//
//  ResourcesViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-07.
//

import UIKit
import Kingfisher
import SideMenu

class ResourcesViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    private let viewModel = ViewModel()
    private var error: OpenNewError?
    private var regions: [Region]?
    private var selectedIndexPath: IndexPath?
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getResourceFromAPI()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        // for the side menu
        MenuUtilities.initMenu(self: self, menu: menu)
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        
        tableViewCellRegister()
        
        // updating data from view model
        viewModel.errorStore.bind { [weak self] error in
            guard let error = error else {
                return
            }
            
            self?.error = error
        }
        
        viewModel.resourcesStore.bind { [weak self] regions in
            guard let regions = regions else {
                return
            }
            
            self?.regions = regions
            self?.myTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let selectedIndexPath = selectedIndexPath else {
            return
        }
        let cell = myTableView.cellForRow(at: selectedIndexPath) as! ResourceCell
        cell.mainView.backgroundColor = .clear
        myTableView.reloadRows(at: [selectedIndexPath], with: .none)

    }
    
    func tableViewCellRegister() {
        myTableView.register(UINib(nibName: "ResourceCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.resourceCell.rawValue)
    }
    
    @IBAction func menuWasTapped(_ sender: Any) {
        present(menu!, animated: true)
    }
}

extension ResourcesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ResourceCell
        cell.mainView.backgroundColor = .systemGray6
        selectedIndexPath = indexPath
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ResourceDetailsVC") as! ResourceDetailsViewController
        
        guard let regions = regions else { return }
        let resource = regions[indexPath.section].resources[indexPath.row]
        
        if let contacts = resource.contacts, contacts.count > 0 {
            destinationVC.data = resource
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else {
            let title = "The resource is empty"
            let message = "The selected resource of \(resource.location) is empty"
            AlertUtilities.showAlert2(self: self, title: title, message: message, actionTitle: "OK", textColor: UIColor.black)
        }
    }
    
}

extension ResourcesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return regions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions?[section].resources.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.resourceCell.rawValue, for: indexPath) as! ResourceCell
        guard let regions = regions else { return cell }
        let ri = regions[indexPath.section].resources[indexPath.row]
        let url = URL(string: ri.logo)!
        cell.resourceImage.kf.setImage(with: url)
        cell.locationLabel.text = ri.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return regions?[section].name ?? nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .systemGray6
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = .black
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

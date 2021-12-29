//
//  MenuListController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-12-03.
//

import UIKit


enum MenuCellIdentifier: String {
    case regularCell = "regularCellIdentifier"
}

class MenuListController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(named: "ColorBlue")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: MenuCellIdentifier.regularCell.rawValue)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCellIdentifier.regularCell.rawValue, for: indexPath)
        cell.backgroundColor = UIColor(named: "ColorBlue")
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.textLabel?.text = "Information Protection Act"
        } else {
            cell.textLabel?.text = "Sign Out"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if indexPath.row == 0 {
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "InforProtectActIdentifier") as! InforProtectActViewController
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
        } else if indexPath.row == 1 {
            KeyChain.logout()
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = destinationVC
        }
    }
}

//
//  MenuUtilities.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-12-03.
//

import Foundation
import UIKit
import SideMenu

class MenuUtilities {
    static func initMenu(self: UIViewController, menu: SideMenuNavigationController?) {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "ColorBlue")
        
        menu?.leftSide = false
        SideMenuManager.default.addPanGestureToPresent(toView: (self.view)!)
        SideMenuManager.default.rightMenuNavigationController = menu
    }
}

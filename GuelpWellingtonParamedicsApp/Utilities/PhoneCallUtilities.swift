//
//  PhoneCallUtilities.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-28.
//

import Foundation
import UIKit

class PhoneCallUtilities {
    static func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt: //\(phoneNumber)"),
        UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

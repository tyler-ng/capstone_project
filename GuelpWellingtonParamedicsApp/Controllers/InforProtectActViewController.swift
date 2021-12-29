//
//  InforProtectActViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-12-03.
//

import UIKit

class InforProtectActViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Personal Health Information Protection Act"
        if #available(iOS 11.0, *) {
            self.textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.textView.attributedText = sampleData.htmlToAttributedString
        self.textView.font = .systemFont(ofSize: 17)
        
    }
}

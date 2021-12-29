//
//  ResourceWebViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-15.
//

import UIKit
import WebKit

class ResourceWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    var url: URL?
    
    var site_url: String? {
        didSet {
            if let site_url = site_url {
                url = URL(string: site_url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = url else { return }
        
        self.title = "\(url)"
        
        let request = URLRequest(url: url)
        
        webView?.load(request)
    }
    
    
}

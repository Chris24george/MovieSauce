//
//  WelcomeViewController.swift
//  
//
//  Created by Jacob Parker on 11/13/18.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let creds = SyncCredentials.nickname("jacob", isAdmin: true)
        
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL, onCompletion: { [weak self](user, err) in
            if let _ = user {
                self?.navigationController?.pushViewController(ItemsViewController(), animated: true)
            } else if let error = err {
                fatalError(error.localizedDescription)
            }
        })
    }
}

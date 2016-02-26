//
//  MainViewController.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/26/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import UIKit


final class MainViewController : UIViewController {
    
    @IBOutlet weak var contactTableView: UIView!
    @IBOutlet weak var favouritesAllSegmentedControl: UISegmentedControl!
    
    let contactsTableViewController : ContactTableViewController
    
    init() {
        contactsTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesAllSegmentedControl.selectedSegmentIndex = 1
        
        UIStoryboard sb = 
        
        
    }
    
}
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
    
    var contactsTableViewController : ContactTableViewController! //let no puedo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouritesAllSegmentedControl.selectedSegmentIndex = 1  //Todos
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.contactsTableViewController = sb.instantiateViewControllerWithIdentifier("ContactTableViewController") as! ContactTableViewController
        self.addChildViewController(self.contactsTableViewController)
        self.contactTableView.addSubview(self.contactsTableViewController.view)
        self.contactsTableViewController.view.frame = self.contactTableView.bounds
        
        self.contactsTableViewController.setViewModel(ContactsAgendaViewModel())
        favouritesAllSegmentedControl.addTarget(self.contactsTableViewController, action: "segmentSelected:", forControlEvents: .ValueChanged)
        
    }
    
    
}
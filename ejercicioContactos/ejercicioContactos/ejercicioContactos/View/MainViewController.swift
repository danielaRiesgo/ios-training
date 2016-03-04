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
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.contactsTableViewController = sb.instantiateViewControllerWithIdentifier("ContactTableViewController") as! ContactTableViewController
        self.addChildViewController(self.contactsTableViewController)
        self.contactTableView.addSubview(self.contactsTableViewController.view)
        self.contactsTableViewController.view.frame = self.contactTableView.bounds
        
        let contactsVM = ContactsAgendaViewModel()
        self.contactsTableViewController.setViewModel(contactsVM)
        favouritesAllSegmentedControl.addTarget(self, action: "segmentSelected:", forControlEvents: .ValueChanged)
        
        let segmentNumber : Int
        switch contactsVM.activeFilter.value {
        case .All:
            segmentNumber = 1
        case .Favourites:
            segmentNumber = 0
        }
        favouritesAllSegmentedControl.selectedSegmentIndex = segmentNumber
    }
    
    func segmentSelected(sender: UISegmentedControl) {
        let newFilter: ContactsAgendaViewModel.Filter
        switch sender.selectedSegmentIndex {
        case 1:
            newFilter = .All
        default: //case 0
            newFilter = .Favourites
        }
        self.contactsTableViewController.segmentSelected(newFilter)
    }
    
}
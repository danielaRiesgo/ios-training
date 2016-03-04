//
//  ContactTableViewController.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/26/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa


final class ContactTableViewController : UITableViewController {
    
    var viewModel : ContactsAgendaViewModel? = .None
    
    func setViewModel(vm : ContactsAgendaViewModel) {
        self.viewModel = vm
        vm.contactsShown.signal.observeOn(UIScheduler()).observeNext { _ in self.tableView.reloadData() }
        //Hay que cambiar el filter para que updatee?
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactTableCell") as! ContactTableCell
        let contact = self.viewModel![indexPath.row]
        cell.bindViewModel(contact)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.contactsCount ?? 0
    }
 
    func segmentSelected(newFilter: ContactsAgendaViewModel.Filter) {
        //print("Llamó a segmentSelected")
        self.viewModel?.activeFilter.value = newFilter
    }
    
}
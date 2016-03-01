//
//  ContactTableViewController.swift
//  ejercicioContactos
//
//  Created by Daniela Riesgo on 2/26/16.
//  Copyright © 2016 Daniela Riesgo. All rights reserved.
//

import Foundation
import UIKit


final class ContactTableViewController : UITableViewController {
    
    var viewModel : ContactsAgendaViewModel? = .None
    
    func setViewModel(vm : ContactsAgendaViewModel) {
        self.viewModel = vm
        self.viewModel!.contactsShown.signal.observeNext { _ in //print("Y acá llama a reload")
                                                                self.tableView.reloadData() }
        self.viewModel!.updateContacts.apply(.None).start()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactTableCell") as! ContactTableCell
        let contact = self.viewModel![indexPath.row]
        cell.bindViewModel(contact, buttonAction: { self.viewModel!.updateFavourites.apply(.None).start() } )
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.contactsCount ?? 0
    }
 
    func segmentSelected(sender: UISegmentedControl) {
        //print("Llamó a segmentSelected")
        self.viewModel!.changeList.apply(sender.selectedSegmentIndex == 0).start()
    }
    
}
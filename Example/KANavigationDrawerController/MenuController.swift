//
//  MenuController.swift
//  KANavigationDrawerController
//
//  Created by Kristoffer Arlefur on 19/04/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import KANavigationDrawerController

class MenuController: KANavigationDrawerMenuController {

    @IBOutlet weak var tableView: UITableView!

    let menuItems = ["First", "Second"]
}

extension MenuController : UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
}

extension MenuController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            menuActionDelegate?.openSegue("openFirst", sender: nil)
        case 1:
            menuActionDelegate?.openSegue("openSecond", sender: nil)
        default:
            break
        }
    }
}

//
//  SendAlertVC.swift
//  HackaBike
//
//  Created by Esdras Martins on 4/17/16.
//  Copyright © 2016 Ezequiel. All rights reserved.
//

import UIKit

class SendAlertVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableAlert: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableAlert.delegate = self
        self.tableAlert.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AlertCell
        cell.labelCell.text = "testando"
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

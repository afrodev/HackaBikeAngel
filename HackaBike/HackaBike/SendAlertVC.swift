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
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var localLabel: UITextField!
    var arrayPosts:[Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableAlert.delegate = self
        self.tableAlert.dataSource = self
        PostController.retornaTodosPosts { (postArray: [Post]) in
            self.arrayPosts = postArray
            self.tableAlert.reloadData()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.titleLabel?.resignFirstResponder()
        self.localLabel?.resignFirstResponder()
    }
    
    @IBAction func textFieldDidReturn(textField: UITextField!) {
        textField.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.title = "FEED"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.arrayPosts.count

    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AlertCell
        cell.labelCell.text = self.arrayPosts[indexPath.row].pessoaNome
        
        return cell
    }

    @IBAction func send(sender: AnyObject) {
        //aaMss em algum lugar pra aparecer dps na table, precisa dar um reload table pra atualizar em tempo real
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Singleton.sharedInstance.pessoaAtual?.name = defaults.objectForKey("userName") as! String
        
        let post = Post()
        post.titulo =  "buraco"
        post.pessoaId = "PJTNQgddai"
        post.latitude = 30.0
        post.longitude = 30.0
        post.pessoaNome = "Nome Teste"
        
        PostController.insertPost(post) { (resp:String?) in
            if resp != nil {
                print("Ïnserido com sucesso")
            } else {
                print("ERRO ")

            }
            
            let ac = UIAlertController(title: "Inserido com sucesso", message: .None, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
            self.navigationController?.popViewControllerAnimated(true)
            
            
            print(resp)
        }
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

//
//  NewItemViewController.swift
//  ToDoList
//
//  Created by Ric Telford on 8/30/15.
//  Copyright (c) 2015 Ric Telford. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var toDoItem = ToDoItem()
    var router = UserAPI()
    
    @IBOutlet weak var responseLabel: UILabel!
    @IBAction func addButton(_ sender: Any) {
        if let name = textField.text, name != "" {
            var add = [String:Any]()
            add["itemName"] = name
            add["completed"] = false
            let date = Date()
            let dateForm = DateFormatter()
            dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
            add["creationDate"] = dateForm.string(from: date)
            print(date)
            print(add["creationDate"] ?? "fail")
            router.post(dbName: router.database, collectionName: router.collection, item: add, completion: { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.responseLabel.text = error!.localizedDescription
                    }
                    return
                }
                guard let _ = data else {
                    DispatchQueue.main.async {
                        self.responseLabel.text = "Error: did not receive data\n"
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.responseLabel.text = "Add record successfully\n"
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((sender as! UIBarButtonItem) != self.saveButton) {
            return
        }
        if (self.textField.text != nil) {
            self.toDoItem.itemName = self.textField.text!
            self.toDoItem.completed = false
        }
    }
}

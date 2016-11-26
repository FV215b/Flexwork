//
//  ViewController.swift
//  Flexwork_midDemo
//
//  Created by Yuchen Zhou on 11/21/16.
//  Copyright © 2016 Yuchen Zhou. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    var router = UserAPI()
    
    @IBOutlet weak var dbName: UITextField!
    @IBOutlet weak var colName: UITextField!
    @IBOutlet weak var getField: UITextField!
    @IBOutlet weak var getValue: UITextField!
    @IBOutlet weak var setID: UITextField!
    @IBOutlet weak var setCount: UITextField!
    @IBOutlet weak var responseWindow: UITextView!
    var statusPicker: UIPickerView!
    let statusViewController = StatusPickerController()
    var responseString = String()
    @IBAction func getAll(_ sender: Any) {
        responseString = ""
        if let db = dbName.text, let col = colName.text, db != "", col != "" {
            router.getAll(db, col, completion: {(resp) -> () in
                if let response = resp {
                    for doc in response {
                        self.responseString += "---------------------\n"
                        for (key, value) in doc {
                            self.responseString += "\(key) = \(value)\n"
                        }
                    }
                    self.responseString += "---------------------\n"
                }
                else {
                    self.responseString = "response is nil"
                }
            })
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    @IBAction func getDoc(_ sender: Any) {
        responseString = ""
        if let db = dbName.text, let col = colName.text, let field = getField.text, let value = getValue.text, db != "", col != "", field != "", value != "" {
            router.get(db, col, statusViewController.getValue(), field, value, completion:  {(resp) -> () in
                if let response = resp {
                    for doc in response {
                        self.responseString += "---------------------\n"
                        for (key, value) in doc {
                            self.responseString += "\(key) = \(value)\n"
                        }
                    }
                    self.responseString += "---------------------\n"
                }
                else {
                    self.responseString = "response is nil"
                }
            })
        }
        else {
            self.responseString = "fill in the required blanks"
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    @IBAction func addDoc(_ sender: Any) {
        responseString = ""
        if let id = setID.text, let count = setCount.text, id != "", count != "" {
            let inputDict: [String:Any] = ["id":id, "count":count]
            if let db = dbName.text, let col = colName.text, db != "", col != "" {
                router.post(db, col, inputDict, completion: {(resp) -> () in
                    if let response = resp, response == "Success" {
                        self.responseString = "Add record successfully\n"
                    }
                    else {
                        self.responseString = "Failed\n"
                    }
                })
            }
            else {
                self.responseString = "Enter database of collection name\n"
            }
        }
        else {
            self.responseString = "Enter id or count\n"
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 90, height: 80))
        statusPicker.center = CGPoint(x: 84, y: 190)
        statusPicker.delegate = statusViewController
        statusPicker.dataSource = statusViewController
        self.addChildViewController(statusViewController)
        self.view.addSubview(statusPicker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


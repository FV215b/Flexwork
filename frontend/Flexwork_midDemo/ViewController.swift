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
    var responseString = String()
    var y: CGFloat = 0
    
    @IBOutlet weak var dbName: UITextField!
    @IBOutlet weak var colName: UITextField!
    
    @IBOutlet weak var getField1: UITextField!
    @IBOutlet weak var getValue1: UITextField!
    @IBOutlet weak var getField2: UITextField!
    @IBOutlet weak var getValue2: UITextField!
    
    @IBOutlet weak var updateField: UITextField!
    @IBOutlet weak var updateValue: UITextField!
    @IBOutlet weak var updateNewID: UITextField!
    @IBOutlet weak var updateNewCount: UITextField!
    
    @IBOutlet weak var addID1: UITextField!
    @IBOutlet weak var addCount1: UITextField!
    @IBOutlet weak var addID2: UITextField!
    @IBOutlet weak var addCount2: UITextField!
    @IBOutlet weak var addID3: UITextField!
    @IBOutlet weak var addCount3: UITextField!
    
    @IBOutlet weak var deleteField: UITextField!
    @IBOutlet weak var deleteValue: UITextField!
    
    @IBOutlet weak var responseWindow: UITextView!
    var statusPicker1: UIPickerView!
    let statusViewController1 = StatusPickerController()
    var statusPicker2: UIPickerView!
    let statusViewController2 = StatusPickerController()
    var statusPicker3: UIPickerView!
    let statusViewController3 = StatusPickerController()
    var statusPicker4: UIPickerView!
    let statusViewController4 = StatusPickerController()
    
    @IBAction func testConnection(_ sender: Any) {
        view.endEditing(true)
        responseString = ""
        router.test(completion: {(data, response, error) -> () in
            self.printResult(data, response, error)
        })
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    @IBAction func getAll(_ sender: Any) {
        view.endEditing(true)
        responseString = ""
        if let db = dbName.text, let col = colName.text, db != "", col != "" {
            router.get(dbName: db, collectionName: col, completion: {(data, response, error) -> () in
                self.printDoc(data, response, error)
            })
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        view.endEditing(true)
        responseString = ""
        if let db = dbName.text, let col = colName.text, db != "", col != "" {
            router.delete(dbName: db, collectionName: col, completion: {(data, response, error) -> () in
                self.printResult(data, response, error)
            })
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    @IBAction func getDoc(_ sender: Any) {
        view.endEditing(true)
        responseString = ""
        if let db = dbName.text, let col = colName.text, db != "", col != "" {
            if let field = getField1.text, let value = getValue1.text, field != "", value != "" {
                if let field2 = getField2.text, let value2 = getValue2.text, field2 != "", value2 != "" {
                    let getFilter1: [String] = [router.getComparisonType(statusViewController1.getValue()), field, value]
                    let getFilter2: [String] = [router.getComparisonType(statusViewController2.getValue()), field2, value2]
                    var getFilterArray = [[String]]()
                    getFilterArray.append(getFilter1)
                    getFilterArray.append(getFilter2)
                    router.get(dbName: db, collectionName: col, filters: getFilterArray, completion: {(data, response, error) -> () in
                        self.printDoc(data, response, error)
                    })
                }
                else {
                    router.get(dbName: db, collectionName: col, operation: statusViewController1.getValue(), field: field, value: value, completion: {(data, response, error) -> () in
                        self.printDoc(data, response, error)
                    })
                }
            }
            else {
                self.responseWindow.text = "The first line field and value shouldn't be empty\n"
            }
        }
        else {
            self.responseString = "Enter database name and collection name\n"
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    @IBAction func updateDoc(_ sender: Any) {
        view.endEditing(true)
        responseString = ""
        if let db = dbName.text, let col = colName.text, db != "", col != "" {
            if let field = updateField.text, let value = updateValue.text, let id = updateNewID.text, let count = updateNewCount.text, field != "", value != "", id != "", count != "" {
                let newItem: [String:Any] = ["id":id, "count":Int(count)!]
                router.put(dbName: db, collectionName: col, operation: statusViewController3.getValue(), field: field, value: value, newItem: newItem, completion: {(data, response, error) -> () in
                    self.printResult(data, response, error)
                })
            }
            else {
                self.responseString = "Enter update conditions\n"
            }
        }
        else {
            self.responseString = "Enter database name and collection name\n"
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    @IBAction func addDoc(_ sender: Any) {
        view.endEditing(true)
        responseString = ""
        if let id = addID1.text, let count = addCount1.text, id != "", count != "" {
            let inputDict: [String:Any] = ["id":id, "count":Int(count)!]
            var inputArray = [[String:Any]]()
            inputArray.append(inputDict)
            if let id = addID2.text, let count = addCount2.text, id != "", count != "" {
                let inputDict2: [String:Any] = ["id":id, "count":Int(count)!]
                inputArray.append(inputDict2)
            }
            if let id = addID3.text, let count = addCount3.text, id != "", count != "" {
                let inputDict3: [String:Any] = ["id":id, "count":Int(count)!]
                inputArray.append(inputDict3)
            }
            if let db = dbName.text, let col = colName.text, db != "", col != "" {
                if inputArray.count == 1 {
                    router.post(dbName: db, collectionName: col, item: inputDict, completion: {(data, response, error) -> () in
                        self.printResult(data, response, error)
                    })
                }
                else {
                    router.post(dbName: db, collectionName: col, items: inputArray, completion: {(data, response, error) -> () in
                        self.printResult(data, response, error)
                    })
                }
            }
            else {
                self.responseString = "Enter database and collection name\n"
            }
        }
        else {
            self.responseString = "The left-most id and count shouldn't be empty\n"
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    @IBAction func deleteDoc(_ sender: Any) {
        view.endEditing(true)
        responseString = ""
        if let db = dbName.text, let col = colName.text, db != "", col != "" {
            if let field = deleteField.text, let value = deleteValue.text, field != "", value != "" {
                router.delete(dbName: db, collectionName: col, operation: statusViewController4.getValue(), field: field, value: value, completion: {(data, response, error) -> () in
                    self.printResult(data, response, error)
                })
            }
            else {
                self.responseString = "Enter delete conditions\n"
            }
        }
        else {
            self.responseString = "Enter database and collection name\n"
        }
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    func printDoc(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        guard error == nil else {
            self.responseString = error!.localizedDescription
            DispatchQueue.main.async {
                self.responseWindow.text = self.responseString
            }
            return
        }
        guard let jsonData = data else {
            self.responseString = "Error: did not receive data\n"
            DispatchQueue.main.async {
                self.responseWindow.text = self.responseString
            }
            return
        }
        do {
            let responseData = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: Any]]
            for doc in responseData {
                self.responseString += "---------------------\n"
                for (key, value) in doc {
                    self.responseString += "\(key) = \(value)\n"
                }
            }
            self.responseString += "---------------------\n"
            DispatchQueue.main.async {
                self.responseWindow.text = self.responseString
            }
        } catch {
            printResult(data, response, error)
            return
        }
    }
    
    func printResult(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        guard error == nil else {
            self.responseString = error!.localizedDescription
            DispatchQueue.main.async {
                self.responseWindow.text = self.responseString
            }
            return
        }
        guard let jsonData = data else {
            self.responseString = "Error: did not receive data\n"
            DispatchQueue.main.async {
                self.responseWindow.text = self.responseString
            }
            return
        }
        self.responseString = String(data: jsonData, encoding: .utf8)!
        DispatchQueue.main.async {
            self.responseWindow.text = self.responseString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusPicker1 = UIPickerView(frame: CGRect(x: 0, y: 0, width: 80, height: 60))
        statusPicker1.center = CGPoint(x: 115, y: 118)
        statusPicker1.delegate = statusViewController1
        statusPicker1.dataSource = statusViewController1
        self.addChildViewController(statusViewController1)
        self.view.addSubview(statusPicker1)
        statusPicker2 = UIPickerView(frame: CGRect(x: 0, y: 0, width: 80, height: 60))
        statusPicker2.center = CGPoint(x: 115, y: 172)
        statusPicker2.delegate = statusViewController2
        statusPicker2.dataSource = statusViewController2
        self.addChildViewController(statusViewController2)
        self.view.addSubview(statusPicker2)
        statusPicker3 = UIPickerView(frame: CGRect(x: 0, y: 0, width: 80, height: 90))
        statusPicker3.center = CGPoint(x: 115, y: 241)
        statusPicker3.delegate = statusViewController3
        statusPicker3.dataSource = statusViewController3
        self.addChildViewController(statusViewController3)
        self.view.addSubview(statusPicker3)
        statusPicker4 = UIPickerView(frame: CGRect(x: 0, y: 0, width: 80, height: 60))
        statusPicker4.center = CGPoint(x: 115, y: 392)
        statusPicker4.delegate = statusViewController4
        statusPicker4.dataSource = statusViewController4
        self.addChildViewController(statusViewController4)
        self.view.addSubview(statusPicker4)
        addID1.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        addID1.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
        addID2.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        addID2.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
        addID3.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        addID3.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
        addCount1.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        addCount1.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
        addCount2.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        addCount2.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
        addCount3.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        addCount3.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
        deleteField.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        deleteField.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
        deleteValue.addTarget(self, action: #selector(ViewController.viewRaiseUp(_:)), for: .editingDidBegin)
        deleteValue.addTarget(self, action: #selector(ViewController.viewFallDown(_:)), for: .editingDidEnd)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // For view rising up
    func viewRaiseUp(_ sender: UITextField!) {
        if y == 0 {
            y = 130
            self.view.bounds.origin.y += y
            self.view.layoutIfNeeded()
        }
    }
    
    // For view dropping down
    func viewFallDown(_ sender: UITextField!) {
        if y == 130 {
            self.view.bounds.origin.y -= y
            self.view.layoutIfNeeded()
            y = 0
        }
    }
}


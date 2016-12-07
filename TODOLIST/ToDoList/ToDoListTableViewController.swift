//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Ric Telford on 8/30/15.
//  Copyright (c) 2015 Ric Telford. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    var toDoItems = [ToDoItem]()
    var router = UserAPI()
    @IBOutlet weak var responseWindow: UILabel!
    
    @IBAction func updateButton(_ sender: Any) {
        router.delete(dbName: router.database, collectionName: router.collection, completion: {(data, response, error) -> () in
            var items = [[String:Any]]()
            for it in self.toDoItems {
                var item = [String:Any]()
                item["itemName"] = it.itemName
                item["completed"] = it.completed
                let dateForm = DateFormatter()
                dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
                item["creationDate"] = dateForm.string(from: it.creationDate)
                items.append(item)
            }
            self.router.post(dbName: self.router.database, collectionName: self.router.collection, items: items, completion: {(data, response, error) -> () in
                self.printResult(data, response, error)
            })
        })
    }
    
    @IBAction func syncButton(_ sender: Any) {
        toDoItems.removeAll()
        tableView.reloadData()
        router.get(dbName: router.database, collectionName: router.collection, completion: {(data, response, error) -> () in
            self.printDoc(data, response, error)
        })
    }
    
    func printDoc(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        guard let jsonData = data else {
            print("Error: did not receive data\n")
            return
        }
        do {
            let responseData = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String:Any]]
            print("responseData = \(responseData)")
            for doc in responseData {
                guard let itemName = doc["itemName"] as? String else {
                    print("missing itemName")
                    return
                }
                guard let completed = doc["completed"] as? Bool else {
                    print("missing completed")
                    return
                }
                guard let creationDate = doc["creationDate"] as? String else {
                    print("missing creationDate")
                    return
                }
                print("itemName: \(itemName)")
                print("completed: \(completed)")
                print("creationDate: \(creationDate)")
                
                let item = ToDoItem()
                item.itemName = itemName
                item.completed = completed
                let dateForm = DateFormatter()
                dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
                item.creationDate = dateForm.date(from: creationDate)!
                toDoItems.append(item)
            }
        } catch {
            printResult(data, response, error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.responseWindow.text = "Syncronise with database successfully"
        }
    }
    
    func printResult(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            DispatchQueue.main.async {
                self.responseWindow.text = error!.localizedDescription
            }
            return
        }
        guard let jsonData = data else {
            print("Error: did not receive data\n")
            DispatchQueue.main.async {
                self.responseWindow.text = error!.localizedDescription
            }
            return
        }
        let responseData = String(data: jsonData, encoding: .utf8)!
        print(responseData)
        DispatchQueue.main.async {
            self.responseWindow.text = responseData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
    }
    
    func loadInitialData() {
        let item1 = ToDoItem()
        item1.itemName = "Mail Package"
        self.toDoItems.append(item1)
        let item2 = ToDoItem()
        item2.itemName = "Buy Lottery Ticket"
        self.toDoItems.append(item2)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListProtoCell", for: indexPath) 
        let tempToDoItem:ToDoItem = self.toDoItems[indexPath.row]
        cell.textLabel?.text = "\(tempToDoItem.itemName)"
        if (tempToDoItem.completed) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let tappedItem:ToDoItem = self.toDoItems[indexPath.row]
        tappedItem.completed = !tappedItem.completed
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }


    
    @IBAction func unwindToList(_ segue: UIStoryboardSegue) {
        let source: NewItemViewController = segue.source as! NewItemViewController
        let item:ToDoItem = source.toDoItem
        if (item.itemName != "") {
            self.toDoItems.append(item) }
        self.tableView.reloadData()
    }

}

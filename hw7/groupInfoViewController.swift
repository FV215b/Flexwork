//
//  TableViewController.swift
//  WEEK3
//
//  Created by Yuchen Zhou on 16/9/13.
//  Copyright © 2016 Duke University. All rights reserved.
//


import UIKit

// This is the controller for TableView
class groupInfoViewController: UITableViewController {
    
    var allItems = [Item]()
    var filteredItems = [Item]()
    var currentIndex: Int! = -1
    var selectedItem: Item!
    let searchController = UISearchController(searchResultsController: nil)
    var router = UserAPI()
    
    @IBAction func syncButton(_ sender: Any) {
        removeAll()
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
                guard let name = doc["name"] as? String else {
                    print("missing name")
                    return
                }
                guard let netID = doc["netID"] as? String else {
                    print("missing netID")
                    return
                }
                guard let gender = doc["gender"] as? Bool else {
                    print("missing gender")
                    return
                }
                guard let team = doc["team"] as? String else {
                    print("missing team")
                    return
                }
                guard let height = doc["height"] as? String else {
                    print("missing height")
                    return
                }
                guard let city = doc["city"] as? String else {
                    print("missing city")
                    return
                }
                guard let languages = doc["languages"] as? [String] else {
                    print("missing languages")
                    return
                }
                guard let hobbies = doc["hobbies"] as? [String] else {
                    print("missing hobbies")
                    return
                }
                var status: Status = .other
                if let degree = (doc["degree"] as? String) {
                    switch degree {
                    case "B.S":
                        status = .bs
                    case "M.S":
                        status = .ms
                    case "Meng":
                        status = .meng
                    case "PhD":
                        status = .phD
                    default:
                        status = .other
                    }
                    print("degree: \(degree)")
                }
                else {
                    print("missing degree")
                    return
                }
                let image1 = UIImage(named: "JianyuZhang")!
                print("name: \(name)")
                print("netID: \(netID)")
                print("gender: \(gender)")
                print("team: \(team)")
                print("height: \(height)")
                print("city: \(city)")
                print("languages: \(languages)")
                print("hobbies: \(hobbies)")

                let item = Item(image: image1, name: name, netID: netID, gender: gender, team: team, height: height, city: city, status: status, languages: languages, hobbies: hobbies)
                allItems.append(item!)
            }
        } catch {
            printResult(data, response, error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func printResult(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        guard error == nil else {
            print("ERROR!!!!!!")
            print(error!.localizedDescription)
            return
        }
        guard let jsonData = data else {
            print("Error: did not receive data\n")
            return
        }
        let responseData = String(data: jsonData, encoding: .utf8)!
        print(responseData)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        if (scope == "Name") {
            filteredItems = allItems.filter{item in
                return item.name.lowercased().contains(searchText.lowercased())}
        }
        else if (scope == "NetID") {
            filteredItems = allItems.filter{item in
                return item.netID.lowercased().contains(searchText.lowercased())}
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Search Bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Name", "NetID"]
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
        loadData()
    }
    
    // Load existing data or initialize data for Team Veggies
    func loadData() {
        // load existing data
        if let archivedItems = loadItems() {
            //print("Load from \(Item.ArchiveURL.path!)")
            allItems += archivedItems
        }
            // initialize data for Team Veggies
        else {
            let image1 = UIImage(named: "YuchenZhou")!
            let item1 = Item(image: image1, name: "Yuchen Zhou", netID: "yz333", gender: true, team: "Veggies", height: "5\'11\"", city: "Hangzhou, Zhejiang, China", status: .ms, languages: ["C","Swift","verilog"], hobbies: ["play video games","watch movies"])
            allItems.append(item1!)
            
            let image2 = UIImage(named: "JiashengYang")!
            let item2 = Item(image: image2, name: "Jiasheng Yang", netID: "jy175", gender: true, team: "Veggies", height: "5\'10\"", city: "Beijing, China", status: .ms, languages: ["C","C++","Python"], hobbies: ["play soccer","hike"])
            allItems.append(item2!)
            
            let image3 = UIImage(named: "JianyuZhang")!
            let item3 = Item(image: image3, name: "Jianyu Zhang", netID: "jz173", gender: true, team: "Veggies", height: "5\'9\"", city: "Nanjing, Jiangsu, China", status: .ms, languages: ["Java","PHP","Python"], hobbies: ["study hard","work hard"])
            allItems.append(item3!)

        }
    }
    
    // Load existing data
    func loadItems() -> [Item]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
    
    // Save current items
    func saveItems() {
        //print("Saving items to \(Item.ArchiveURL.path!)")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allItems, toFile: Item.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save")
        }
        else {
            print("Saved successfully")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count + 1
        }
        // #warning Incomplete implementation, return the number of rows
        return self.allItems.count + 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "TeamViewCell", for: indexPath) as! TeamViewCell
            cell1.teamName.text = "Veggies"
            cell1.teamMember.text = "\(allItems.count)"
            return cell1
        }
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "GroupInfoViewCell", for: indexPath) as! GroupInfoViewCell
        cell2.editButton.tag = (indexPath as NSIndexPath).row - 1
        //cell2.sendButton.tag = (indexPath as NSIndexPath).row - 1
        
        // Configure the cell...
        
        let tempItem: Item
        if searchController.isActive && searchController.searchBar.text != "" {
            tempItem = filteredItems[(indexPath as NSIndexPath).row - 1]
        }
        else {
            tempItem = allItems[(indexPath as NSIndexPath).row - 1]
        }
        cell2.textLabel?.text = tempItem.name
        cell2.detailTextLabel?.text = tempItem.netID
        cell2.imageView?.image = tempItem.image
        
        return cell2
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (indexPath as NSIndexPath).row == 0 {
                return
            }
            // Delete the row from the data source
            let item = self.allItems[(indexPath as NSIndexPath).row - 1]
            removeItem(item)
            print("Remove No.\((indexPath as NSIndexPath).row)'s info")
            saveItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func removeAll() {
        allItems.removeAll()
        tableView.reloadData()
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    // Determine which cell is selected under which scene(search or normal)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastSelected = (indexPath as NSIndexPath).row - 1
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedItem = filteredItems[lastSelected]
            currentIndex = allItems.index(of: selectedItem)
        }
        else {
            selectedItem = allItems[lastSelected]
            currentIndex = lastSelected
        }
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Show No.\(currentIndex+1)'s detail
        if segue.identifier == "Detail" {
            let dest:detailViewController = segue.destination as! detailViewController
            dest.item = selectedItem
            dest.number = currentIndex
        }
            // Edit No.\(currentIndex+1)'s info
        else if segue.identifier == "Edit" {
            let editDest:addViewController = segue.destination as! addViewController
            if searchController.isActive && searchController.searchBar.text != "" {
                editDest.item = filteredItems[(sender! as AnyObject).tag]
                editDest.number = allItems.index(of: filteredItems[(sender! as AnyObject).tag])
            }
            else {
                editDest.item = allItems[(sender! as AnyObject).tag]
                editDest.number = (sender! as AnyObject).tag
            }
        }
            // Add new item
        else if segue.identifier == "Add" {
        }
    }
    
    @IBAction func unwindToList(_ segue: UIStoryboardSegue) {
        if let source: addViewController = segue.source as? addViewController, let item = source.item {
            if source.number != nil {
                allItems[source.number!] = item
            }
                //else if item.firstName == "" || item.lastName == "" || item.netID == "" {}
            else {
                allItems.append(item)
            }
            tableView.reloadData()
            saveItems()
        }
    }
}

extension groupInfoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension groupInfoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}


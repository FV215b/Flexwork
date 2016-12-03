import Foundation

/**
 * Make something final
 *
 */

public class UserAPI {
    let databaseIP = "54.86.116.199"
    let databasePort = "8090"
    let databaseName = "test_db"
    let collectionName = "test_collection"
    var testDB: [[String:Any]] = [["id":"rt113", "count":1130], ["id":"rt113", "count":75], ["id":"rt113", "count":23], ["id":"yz333", "count":23], ["id":"yz333", "count":75], ["id":"jy175", "count":66], ["id":"jy175", "count":75], ["id":"jz173", "count":113], ["id":"jz173", "count":173], ["id":"rt113", "count":113]]
    
    func getComparisonType(_ op: Comparison) -> String {
        switch op {
        case .lessThan:
            return "lessThan"
        case .lessThanOrEqualTo:
            return "lessThanOrEqualTo"
        case .greaterThan:
            return "greaterThan"
        case .greaterThanOrEqualTo:
            return "greaterThanOrEqualTo"
        case .notEqualTo:
            return "notEqualTo"
        default:
            return "equalTo"
        }
    }
    
    func getAll(_ db: String, _ col: String, completion: @escaping (_ resp: [[String:Any]]?) -> ()) {
        completion(testDB)
    }
    
    func get(_ db: String, _ col: String, _ op: Comparison, _ field: String, _ value: String, completion: @escaping (_ resp: [[String:Any]]?) -> ()) {
        let operation: String = getComparisonType(op)
        let url = URL(string: "http://\(databaseIP):\(databasePort)/\(db)/\(col)?op=\(operation)&field=\(field)&value=\(value)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//P.S This part of code works when server is running
        
        /*let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let sendBackData = data, let sendBackResponse = response {
                do {
                    print("response = \(sendBackResponse)")
                    print("****************")
                    print("data = \(sendBackData)")
                    let result = try JSONSerialization.jsonObject(with: sendBackData, options: []) as! [[String:Any]]
                    print("result = \(result)")
                    completion(result)
                } catch let error as NSError {
                    print(error)
                }
            } else {
                print("error = \(error!.localizedDescription)")*/
        
        var result = [[String:Any]]()
        switch op {
        case .equalTo:
            for doc in self.testDB {
                if (field == "id" && value == (doc["id"] as! String)) || (field == "count" && Int(value)! == (doc["count"] as! Int)) {
                    result.append(doc)
                }
            }
            completion(result)
        case .lessThan:
            for doc in self.testDB {
                if (field == "id" && value > (doc["id"] as! String)) || (field == "count" && Int(value)! > (doc["count"] as! Int)) {
                    result.append(doc)
                }
            }
            completion(result)
        case .lessThanOrEqualTo:
            for doc in self.testDB {
                if (field == "id" && value >= (doc["id"] as! String)) || (field == "count" && Int(value)! >= (doc["count"] as! Int)) {
                    result.append(doc)
                }
            }
            completion(result)
        case .greaterThan:
            for doc in self.testDB {
                if (field == "id" && value < (doc["id"] as! String)) || (field == "count" && Int(value)! < (doc["count"] as! Int)) {
                    result.append(doc)
                }
            }
            completion(result)
        case .greaterThanOrEqualTo:
            for doc in self.testDB {
                if (field == "id" && value <= (doc["id"] as! String)) || (field == "count" && Int(value)! <= (doc["count"] as! Int)) {
                    result.append(doc)
                }
            }
            completion(result)
        default:
            for doc in self.testDB {
                if (field == "id" && value != (doc["id"] as! String)) || (field == "count" && Int(value)! != (doc["count"] as! Int)) {
                    result.append(doc)
                }
            }
            completion(result)
        }
        
            //}
        //}
        //task.resume()
    }
    
    func post(_ db: String, _ col: String, _ item: [String:Any], completion: @escaping (_ response: String?) -> ()){
        let url = URL(string: "http://\(databaseIP):\(databasePort)/\(databaseName)/\(collectionName)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: item, options: [])
        } catch let error as NSError {
            print(error)
        }
        
//P.S This part of code works when server is running
        
        /*let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let sendBackData = data, let _ = response {
                do {
                    let result = try JSONSerialization.jsonObject(with: sendBackData, options: []) as! String
                    print(result)
                    completion(result)
                } catch let error as NSError {
                    print(error)
                }
            }
            else {*/
        var it: [String:Any] = item
        it["count"] = Int(item["count"] as! String)!
        self.testDB.append(it)
        completion("Success")
        
            //}
        //}
        //task.resume()
    }
}

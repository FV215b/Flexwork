import Foundation

public class UserAPI {
    let IP = "54.89.248.15"
    let port = "8090"
    let database = "test_db"
    let collection = "test_collection"
    var testDB: [[String:Any]] = [["id":"rt113", "count":1130], ["id":"rt113", "count":75], ["id":"rt113", "count":23], ["id":"yz333", "count":23], ["id":"yz333", "count":75], ["id":"jy175", "count":66], ["id":"jy175", "count":75], ["id":"jz173", "count":113], ["id":"jz173", "count":173], ["id":"rt113", "count":113]]
    
    func test(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        let url = URL(string: "http://\(IP):\(port)/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func get(dbName: String, collectionName: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        let url = URL(string: "http://\(IP):\(port)/\(dbName)/\(collectionName)/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func get(dbName: String, collectionName: String, operation: Comparison, field: String, value: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        let op = getComparisonType(operation)
        let url = URL(string: "http://\(IP):\(port)/\(dbName)/\(collectionName)?op=\(op)&field=\(field)&value=\(value)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func get(dbName: String, collectionName: String, filters: [[String]], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        var stringUrl = "http://\(IP):\(port)/\(dbName)/\(collectionName)/\(filters.count)/and?"
        for i in 1...filters.count {
            stringUrl.append("op\(i)=\(filters[i-1][0])&")
            stringUrl.append("field\(i)=\(filters[i-1][1])&")
            stringUrl.append("value\(i)=\(filters[i-1][2])&")
        }
        let url = URL(string: stringUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
        
        /*var result = [[String:Any]]()
        switch operation {
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
        }*/
    }
    
    func put(dbName: String, collectionName: String, operation: Comparison, field: String, value: String, newItem: [String:Any], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        let op = getComparisonType(operation)
        let url = URL(string: "http://\(IP):\(port)/\(dbName)/\(collectionName)?op=\(op)&field=\(field)&value=\(value)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newItem, options: [])
        } catch let error as NSError {
            print(error)
        }
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func post(dbName: String, collectionName: String, item: [String:Any], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()){
        let url = URL(string: "http://\(IP):\(port)/\(dbName)/\(collectionName)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: item, options: [])
        } catch let error as NSError {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func post(dbName: String, collectionName: String, items: [[String:Any]], completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()){
        let url = URL(string: "http://\(IP):\(port)/\(dbName)/\(collectionName)/\(items.count)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: items, options: [])
        } catch let error as NSError {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
        
        /*var it: [String:Any] = item
        it["count"] = Int(item["count"] as! String)!
        self.testDB.append(it)
        completion("Success")*/
    }
    
    func delete(dbName: String, collectionName: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        let url = URL(string: "http://\(IP):\(port)/\(dbName)/\(collectionName)/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func delete(dbName: String, collectionName: String, operation: Comparison, field: String, value: String, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        let op = getComparisonType(operation)
        let url = URL(string: "http://\(IP):\(port)/\(dbName)/\(collectionName)?op=\(op)&field=\(field)&value=\(value)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
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
}

import Foundation

/**
 * Make something final
 *
 */

public class UserAPI {
    func get(_ db: String, _ col: String, _ op: Comparison, _ field: String, _ value: String, completion: @escaping ([String]) -> ()) {
        let operation: String
        switch op {
        case .lessThan:
            operation = "lessThan"
        case .lessThanOrEqualTo:
            operation = "lessThanOrEqualTo"
        case .greaterThan:
            operation = "greaterThan"
        case .greaterThanOrEqualTo:
            operation = "greaterThanOrEqualTo"
        case .notEqualTo:
            operation = "notEqualTo"
        default:
            operation = "equalTo"   
        }
        let url = URL(string: "http://127.0.0.1:8080/\(db)/\(col)?op=\(operation)&field=\(field)&value=\(value)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {
                do {
                    let res = try JSONSerialization.jsonObject(with: data, options: []) as! [String:[Data]]
                    var docArray = [String]()
                    for doc in res["doc"]! {
                        docArray.append(try JSONSerialization.jsonObject(with: doc, options: []) as! String)
                    }
                    completion(docArray)
                } catch let error as NSError {
                    print(error)
                }
            } else {
                print("error=\(error!.localizedDescription)")
            }
        }
        task.resume()
    }    
}

import Foundation

/**
 * Make something final
 *
 */

public class UserAPI {
/*    func get(_ db: String, _ col: String, _ op: String, _ field: String, _ val: String, completion: (String) -> ()) {
        let url = URL(string: "http://127.0.0.1:8080/\(db)/\(col)?op=\(op)&field=\(field)&value=\(val)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //let getBody: [String:String] = ["operation": op, "field": filt, "value": val]
        //request.httpBody = JSONSerialization.data(withJSONObject: getBody, options: .prettyPrinted)
        let task = URLSession.shared().dataTask(with: request) {
            data, response, error in
            if let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                    completion(jsonString)
            } else {
                print("error=\(error!.localizedDescription)")
            }
        }
        task.resume()
    }    */
}

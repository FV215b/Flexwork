import MongoKitten
import Foundation
import LoggerAPI
import Kitura
import SwiftyJSON

class AllRemoteOriginMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Swift.Void) {
        response.headers["Access-Control-Allow-Origin"] = "*"
        next()
    }
}

// FlexworkController is used for handling http request and sending response back.
public class FlexworkController {
    
    public let flexwork: Flexwork!
    public let router = Router()

    public init(backend: Flexwork) {
        self.flexwork = backend
        setupRouter()
    }

    private func setupRouter() {
        router.all("/*", middleware: AllRemoteOriginMiddleware())
        router.all("/*", middleware: BodyParser())
        router.get("/:dbname/:collectionname", handler: onGetItems)
        //router.get("/get_json_body", handler: onGetJsonBody)
        router.get("/", handler: onGetTest)
        router.post("/:dbname/:collectionname",handler: onPostItems)
        // router.put("/:dbname/:collectionname/:id", onPutItems)
        // router.patch("/:dbname/:collectionname/:id", onPatchItems)
        // router.delete("/:dbname/:collectionname/:id", onDeleteItems)
    }
    private func onGetTest(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        do {
            try response.send("Connecting to Flexwork!").end() 
        } catch {
            Log.error("Error in testing connection")
        }
    }

    private func onPostItems(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        print(dbName)
        print(colName)
        guard let requestBody = request.body else {
            print("request body is nil")
            response.status(.badRequest)//.send("request body is nil").end()
            Log.error("Body contains invalid JSON")
            return
        }
        guard case let .json(json) = requestBody else {
            response.status(.badRequest)
            Log.error("Body contains invalid JSON")
            return
        }
        print("json = \(json)")
        let dict: [String:Any] = json.object as! [String:Any]
        print("dict = \(dict)")
        var docDict = [(String, Value)]()
        for (key, val) in dict {
            if let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: key) {
            switch fieldType {
            case .int32:
                let temp: (String, Value) = (key, ~Int32(val as! Int))
                docDict.append(temp)
                print("\(key) has int \(val)")
            case .boolean:
                let temp: (String, Value) = (key, ~(val as! Bool))
                docDict.append(temp)
                print("\(key) has bool \(val)")
            case .double:
                let temp: (String, Value) = (key, ~(val as! Double))
                docDict.append(temp)
                print("\(key) has double \(val)")
            default:
                let temp: (String, Value) = (key, ~(val as! String))
                docDict.append(temp)
                print("\(key) has string \(val)")
            }
            }
            else {
                print("fieldType \(key) is nil")
            }
        }
        print("docDict = \(docDict)")
        /*var dataToSend = Data()
        do {
            print("dataToSend start")
            dataToSend = try JSONSerialization.data(withJSONObject: docDict, options: .prettyPrinted)
            print("dataToSend success")
        } catch  {
            response.status(.badRequest)
            Log.error("Body parsing failed")
            return
        }
        if let dataString = NSString(data: dataToSend, encoding: String.Encoding.utf8.rawValue){
            print("dataString = \(dataString)") */

            let doc: Document = Document(dictionaryElements: docDict)
            print("doc = \(doc)")
            flexwork.insert(databaseName: dbName, collectionName: colName, document: doc)
        /*}
        else {
            response.status(.badRequest)
            Log.error("Body parsing failed")
            return
        }*/
        do {
            try response.status(.OK).send("Success").end()
        } catch {
            Log.error("Error sending response")
        }
    }

    private func onGetItems(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        let operation = request.queryParameters["op"] ?? ""
        let field = request.queryParameters["field"] ?? ""
        let value = request.queryParameters["value"] ?? ""
        let opComparison: Comparison = getEnumComparisonType(op: operation)

        guard let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: field) else {
            do {
                try response.status(.badRequest).send("Field type does not exist").end()
            } catch {
                Log.error("Error sending response")
            }
            return 
        }

        let parseQuery: Query?
        do {
        switch fieldType {
            case .int32:
                let valWithType = Int32(value)!
                parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valWithType, comparisonOperator: opComparison)
            case .boolean:
                let valWithType = Bool(value)!
                try parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valWithType, comparisonOperator: opComparison)
            case .double:
                let valWithType = Double(value)!
                parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valWithType, comparisonOperator: opComparison)
            default:
                let valWithType = String(value)!
                parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valWithType, comparisonOperator: opComparison)
            }
        } catch let error as FlexworkError {
            parseQuery = nil
            FlexworkError.handleError(flexworkError: error)
        } catch {
            parseQuery = nil
            Log.error("Exception when building a query document")
        }
        
        //******************************************** testing
        print("fieldType: \(fieldType)")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        print("op: \(operation)")
        print("field: \(field)")
        print("value: \(value)")
        print("fieldType: \(fieldType)")
        //********************************************

        
        if let docs = flexwork.find(databaseName: dbName, collectionName: colName, query: parseQuery!) {
            let returnDict: [[String:Any]] = Array(docs).flatMap {
                doc in

                var element = [String:Any]()
                for (key, value) in doc {
                    guard key != "_id" else {
                        continue
                    }
                    guard let type = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: key) else{
                        do {
                            try response.status(.badRequest).send("Field type does not exist").end()
                        } catch {
                            Log.error("Error sending response")
                        }
                        return nil
                    }
                    switch type {
                    case .int32:
                        element[key] = value.int
                    case .boolean:
                        element[key] = value.bool
                    case .double:
                        element[key] = value.double
                    default:
                        element[key] = value.string
                    }
                }
                return element
            }
            print("return dict = \(returnDict)")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: returnDict, options: [])
                print("\(jsonData)")
                try response.send(data: jsonData).end()
            } catch {
                print("Error sending response")
                Log.error("Error sending response")
            }
        } else {
            do {
                try response.status(.badRequest).send("Cannot get requested data").end()
            } catch {
                print("Error sending response")
                Log.error("Error sending response") 
            }
        }
    }

    private func onGetJsonBody(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let parseBody = request.body else {
            next()
            return
        }

        do {
            try response.send("\(parseBody)").end()
        } catch {

        }
    }

    private func getEnumComparisonType(op: String) -> Comparison {
        switch op {
        case "lessThan": 
            return .lessThan
        case "lessThanOrEqualTo": 
            return .lessThanOrEqualTo
        case "greaterThan": 
            return .greaterThan
        case "greaterThanOrEqualTo": 
            return .greaterThanOrEqualTo
        case "notEqualTo": 
            return .notEqualTo
        default: 
            return .equalTo
        }
    }
}

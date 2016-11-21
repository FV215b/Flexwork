import MongoKitten
import Foundation
import LoggerAPI
import Kitura
import SwiftyJSON

/*public indirect enum ParsedBody {
    case json(JSON)
    case text
    case raw
    case multipart
    case urlEncoded
    case asJSON
    case asMultiPart
    case asText
    case asURLEncode
}*/

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
            try response.send("Hello World").end() 
        } catch {

        }
    }

    private func onPostItems(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        print(dbName)
        print(colName)
        guard case let .json(json) = request.body! else {
            response.status(.badRequest)
            Log.error("Body contains invalid JSON")
            return
        }
        print("json = \(json)")
        let dict: [String:Any] = json.object as! [String:Any]
        print("dict = \(dict)")
        var dataToSend = Data()
        do {
            dataToSend = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        } catch  {
            response.status(.badRequest)
            Log.error("Body parsing failed")
            return
        }
        if let dataString = NSString(data: dataToSend, encoding: String.Encoding.utf8.rawValue){
            print("dataString = \(dataString)") 
//Above is all ok
            let doc: Document = Document(data: dataToSend)
// Here it prints nothing, Although I tried to init it with Data/Uint8/Array/DictionaryElement/DictionaryLiteral 
            print("doc = \(doc)")
            flexwork.insert(databaseName: dbName, collectionName: colName, document: doc)
        }
        else {
            response.status(.badRequest)
            Log.error("Body parsing failed")
            return
        }
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
        let opComparison: Comparison
        let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: field)!
        
        switch operation {
        // !!!!!!!!!!!!!! you need to cast the unicode back to the operator you defined.
        // also encapsulate this switch code into a getOperation() method. cuz you will reuse these code
        case "lessThan": //"<"
            opComparison = .lessThan
        case "lessThanOrEqualTo": //"<="
            opComparison = .lessThanOrEqualTo
        case "greaterThan": //">"
            opComparison = .greaterThan
        case "greaterThanOrEqualTo": //">="
            opComparison = .greaterThanOrEqualTo
        case "notEqualTo": //"!="
            opComparison = .notEqualTo
        default: //"="
            opComparison = .equalTo
        }
        
        let parseQuery: Query
        switch fieldType {
        case .int:
            let v = Int(value)!
            parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: v, comparisonOperator: opComparison)
        case .bool:
            let v = Bool(value)!
            parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: v, comparisonOperator: opComparison)
        case .double:
            let v = Double(value)!
            parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: v, comparisonOperator: opComparison)
        default:
            let v = String(value)!
            parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: v, comparisonOperator: opComparison)
        }
        
        //******************************************** testing
        print("fieldType: \(fieldType)")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        print("op: \(operation)")
        print("field: \(field)")
        print("value: \(value)")
        print("fieldType: \(fieldType)")
        
        var res = [String: [String]]()
        res["doc"] = [String]()
        let docs = flexwork.find(databaseName: dbName, collectionName: colName, query: parseQuery)
            for doc in docs {
                res["doc"]!.append(doc.makeExtendedJSON())
                print("doc: \(doc)")
                print("doc.makeExtendedJSON(): \(doc.makeExtendedJSON())")
            }
        //********************************************
        print("res: \(res)")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: res, options: [])
            print("\(jsonData)")
            //try response.send("\(res)").end()
            try response.send(data: jsonData).end()
        } catch {
            
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
}

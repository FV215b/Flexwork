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
        router.all("/get_json_body", middleware: BodyParser())
        router.get("/:dbname/:collectionname", handler: onGetItems)
        router.get("/get_json_body", handler: onGetJsonBody)
        router.get("/", handler: onGetTest)
        // router.post("/:dbname/:collectionname/:id", onPostItems)
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

    private func onGetItems(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        let operation = request.queryParameters["op"] ?? ""
        let field = request.queryParameters["field"] ?? ""
        let value = request.queryParameters["value"] ?? ""
        let opComparison: Comparison
        switch operation {
        case "<":
            opComparison = .lessThan
        case "<=":
            opComparison = .lessThanOrEqualTo
        case ">":
            opComparison = .greaterThan
        case ">=":
            opComparison = .greaterThanOrEqualTo
        case "!=":
            opComparison = .notEqualTo
        default:
            opComparison = .equalTo
        }
        let parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: value, comparisonOperator: opComparison)
        //********************************************
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        print("op: \(operation)")
        print("field: \(field)")
        print("value: \(value)")
        let docs = flexwork.find(collectionName: colName, query: parseQuery)
            for doc in docs {
                print("\(doc)")
            }
        //********************************************
        do {
            try response.send("\(flexwork.find(collectionName: colName, query: parseQuery))").end()
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

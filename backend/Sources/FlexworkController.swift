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
        router.get("/:dbname/:collectionname/:filters/:binding", handler: onGetByMultipleFilters)
        router.get("/", handler: onGetTest)
        router.post("/:dbname/:collectionname", handler: onPostItems)
        router.put("/:dbname/:collectionname", handler: onPutItems)
        router.delete("/:dbname/:collectionname", handler: onDeleteItems)
        router.delete("/:dbname/:collectionname/all", handler: onDeleteAll)
    }
    private func onGetTest(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        do {
            try response.status(.OK).send("Connecting to Flexwork!").end() 
        } catch {
            Log.error("Error in testing connection")
        }
    }

    private func onPutItems(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        let operation = request.queryParameters["op"] ?? ""
        let field = request.queryParameters["field"] ?? ""
        let value = request.queryParameters["value"] ?? ""
        //******************************************** testing
        print("********************************************")
        print("PUT Request...")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        print("operation: \(operation)")
        print("field: \(field)")
        print("value: \(value)")
        //********************************************
        let opComparison: Comparison = getEnumComparisonType(operation)
        guard let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: field) else {
            do {
                try response.status(.badRequest).send("Error. Field not exist").end()
            } catch {
                Log.error("Error sending response")
            }
            return
        }
        print("fieldType: \(fieldType)")
        let parseQuery: Query? = buildQueryWithType(dbName: dbName, colName: colName, op: opComparison, field:field, fieldType: fieldType, value: value)
        if let count = flexwork.count(databaseName: dbName, collectionName: colName, query: parseQuery!) {
            if count != 0 {
                guard let requestBody = request.body else {
                    do {
                        try response.status(.badRequest).send("Error. Request body is empty").end()
                    } catch {
                        Log.error("Error sending response")
                    }
                    return
                }
                guard case let .json(json) = requestBody else {
                    do {
                        try response.status(.badRequest).send("Error. Body contains invalid JSON").end()
                    } catch {
                        Log.error("Error sending response")
                    }
                    return
                }
                print("json = \(json)")
                let dict: [String:Any] = json.object as! [String:Any]
                print("dict = \(dict)")
                var docDict = [(String, Value)]()
                for (key, val) in dict {
                    guard let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: key) else {
                        do {
                            try response.status(.badRequest).send("Error. Field not exist").end()
                        } catch {
                            Log.error("Error sending response")
                        }
                        return
                    }
                    let temp = convertToDocument(key: key, val: val, fieldType: fieldType)
                    docDict.append(temp)
                }
                print("docDict = \(docDict)")
                let doc: Document = Document(dictionaryElements: docDict)
                print("doc = \(doc)")
                flexwork.update(databaseName: dbName, collectionName: colName, query: parseQuery!, document: doc)
                do {
                    try response.status(.OK).send("Update successfully").end()
                } catch {
                    Log.error("Error sending response")
                }
            }
            else {
                do {
                    try response.status(.badRequest).send("Update failed. No matching record").end()
                } catch {
                    Log.error("Error sending response")
                }
            }
        }
        else {
            do {
                try response.status(.badRequest).send("Error Counting database").end()
            } catch {
                Log.error("Error sending response")
            }
        }
    }

    private func onDeleteAll(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        //******************************************** testing
        print("********************************************")
        print("DELETE All Request...")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        //********************************************
        let dummyQuery: Query? = buildQueryWithType(dbName: dbName, colName: colName, op: .notEqualTo, field:"_id", fieldType: .objectId, value: "000000000000000000000000")
        if let count = flexwork.count(databaseName: dbName, collectionName: colName, query: dummyQuery!) {
            if count != 0 {
                flexwork.delete(databaseName: dbName, collectionName: colName, query: dummyQuery!)
                do {
                    try response.status(.OK).send("Delete all \(count) records successfully").end()
                } catch {
                    Log.error("Error sending response")
                }
            }
            else {
                do {
                    try response.status(.badRequest).send("Delete failed. No record exist").end()
                } catch {
                    Log.error("Error sending response")
                }
            }
        }
        else {
            do {
                try response.status(.badRequest).send("Error Counting database").end()
            } catch {
                Log.error("Error sending response")
            }
        }
    }

    private func onDeleteItems(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        let operation = request.queryParameters["op"] ?? ""
        let field = request.queryParameters["field"] ?? ""
        let value = request.queryParameters["value"] ?? ""
        //******************************************** testing
        print("********************************************")
        print("DELETE Request...")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        print("operation: \(operation)")
        print("field: \(field)")
        print("value: \(value)")
        //********************************************
        let opComparison: Comparison = getEnumComparisonType(operation)
        guard let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: field) else {
            do {
                try response.status(.badRequest).send("Error. Field not exist").end()
            } catch {
                Log.error("Error sending response")
            }
            return
        }
        print("fieldType: \(fieldType)")
        let parseQuery: Query? = buildQueryWithType(dbName: dbName, colName: colName, op: opComparison, field:field, fieldType: fieldType, value: value)
        if let count = flexwork.count(databaseName: dbName, collectionName: colName, query: parseQuery!) {
            if count != 0 {
                flexwork.delete(databaseName: dbName, collectionName: colName, query: parseQuery!)
                do {
                    try response.status(.OK).send("Delete \(count) records successfully").end()
                } catch {
                    Log.error("Error sending response")
                }
            }
            else {
                do {
                    try response.status(.badRequest).send("Delete failed. No matching record").end()
                } catch {
                    Log.error("Error sending response")
                }
            }
        }
        else {
            do {
                try response.status(.badRequest).send("Error Counting database").end()
            } catch {
                Log.error("Error sending response")
            }
        }
    }

    private func onPostItems(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        print("********************************************")
        print("POST Request...")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        guard let requestBody = request.body else {
            do {
                try response.status(.badRequest).send("Error. Request body is empty").end()
            } catch {
                Log.error("Error sending response")
            }
            return
        }
        guard case let .json(json) = requestBody else {
            do {
                try response.status(.badRequest).send("Error. Body contains invalid JSON").end()
            } catch {
                Log.error("Error sending response")
            }
            return
        }
        print("json = \(json)")
        let dict: [String:Any] = json.object as! [String:Any]
        print("dict = \(dict)")
        var docDict = [(String, Value)]()
        for (key, val) in dict {
            guard let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: key) else {
                do {
                    try response.status(.badRequest).send("Error. Field not exist").end()
                } catch {
                    Log.error("Error sending response")
                }
                return
            }
            let temp = convertToDocument(key: key, val: val, fieldType: fieldType)
            docDict.append(temp)
        }
        print("docDict = \(docDict)")

        let doc: Document = Document(dictionaryElements: docDict)
        print("doc = \(doc)")
        flexwork.insert(databaseName: dbName, collectionName: colName, document: doc)
        do {
            try response.status(.OK).send("Create successfully").end()
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
        //******************************************** testing
        print("********************************************")
        print("GET Request...")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        print("operation: \(operation)")
        print("field: \(field)")
        print("value: \(value)")
        //********************************************
        let opComparison: Comparison = getEnumComparisonType(operation)
        guard let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: field) else {
            do {
                try response.status(.badRequest).send("Error. Field not exist").end()
            } catch {
                Log.error("Error sending response")
            }
            return
        }
        print("fieldType: \(fieldType)")
        let parseQuery: Query? = buildQueryWithType(dbName: dbName, colName: colName, op: opComparison, field:field, fieldType: fieldType, value: value) 
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
                            try response.status(.badRequest).send("Error. Field not exist").end()
                        } catch {
                            Log.error("Error sending response")
                        }
                        return nil
                    }
                    if type == .int32 {
                        element[key] = value.int
                    }
                    else {
                        element[key] = value.storedValue
                    }
                    /*switch type {
                    case .int32, .int64:
                        element[key] = value.int
                    case .binary:
                        element[key] = value.storedValue
                    case .boolean:
                        element[key] = value.bool
                    case .double:
                        element[key] = value.double
                    case .array, .document:
                        element[key] = value.document
                    case .dateTime:
                        element[key] = value.storedValue
                    case .objectId:
                        element[key] = value.string
                    case .regularExpression:
                        element[key] = value.storedValue
                    case .timestamp:
                        element[key] = value.string
                    case .javascriptCode, .javascriptCodeWithScope:
                        element[key] = value.storedValue
                    case .null:
                        element[key] = nil
                    default:
                        element[key] = value.string
                    }*/
                }
                return element
            }
            print("return dict = \(returnDict)")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: returnDict, options: .prettyPrinted)
                print("jsondata = \(jsonData)")
                try response.status(.OK).send(data: jsonData).end()
            } catch {
                print("Error sending response")
                Log.error("Error sending response")
            }
        } else {
            do {
                try response.status(.badRequest).send("Get failed. Cannot get requested data").end()
            } catch {
                print("Error sending response")
                Log.error("Error sending response") 
            }
        }
    }

    private func onGetByMultipleFilters(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        let dbName = request.parameters["dbname"] ?? ""
        let colName = request.parameters["collectionname"] ?? ""
        let filters = Int(request.parameters["filters"] ?? "0")!
        let binding = request.parameters["binding"] ?? "and"
        //******************************************** testing
        print("********************************************")
        print("GET Multiple Request...")
        print("dbName: \(dbName)")
        print("collectionName: \(colName)")
        print("filters: \(filters)")
        print("binding: \(binding)")
        //********************************************
        var arrayQuery = [Query?]()
        for i in 1...filters {
            let opName = "op\(i)"
            let fieldName = "field\(i)"
            let valueName = "value\(i)"
            let operation = request.queryParameters["\(opName)"] ?? ""
            let field = request.queryParameters["\(fieldName)"] ?? ""
            let value = request.queryParameters["\(valueName)"] ?? ""
            let opComparison: Comparison = getEnumComparisonType(operation)
            guard let fieldType = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: field) else {
                do {
                    try response.status(.badRequest).send("Error. Field not exist").end()
                } catch {
                    Log.error("Error sending response")
                }
                return
            }
            print("operation\(i): \(operation)")
            print("field\(i): \(field)")
            print("value\(i): \(value)")
            print("fieldType\(i): \(fieldType)")
            let parseQuery: Query? = buildQueryWithType(dbName: dbName, colName: colName, op: opComparison, field:field, fieldType: fieldType, value: value)
            arrayQuery.append(parseQuery)      
        }
        var sumQuery = arrayQuery[0]!
        for i in 1..<arrayQuery.count {
            if let q = arrayQuery[i] {
                sumQuery = binding == "or" ? (sumQuery || q) : (sumQuery && q)
            }
        }
        if let docs = flexwork.find(databaseName: dbName, collectionName: colName, query: sumQuery) {
            let returnDict: [[String:Any]] = Array(docs).flatMap {
                doc in

                var element = [String:Any]()
                for (key, value) in doc {
                    guard key != "_id" else {
                        continue
                    }
                    guard let type = flexwork.getFieldType(databaseName: dbName, collectionName: colName, fieldName: key) else{
                        do {
                            try response.status(.badRequest).send("Error. Field not exist").end()
                        } catch {
                            Log.error("Error sending response")
                        }
                        return nil
                    }
                    if type == .int32 {
                        element[key] = value.int
                    }
                    else {
                        element[key] = value.storedValue
                    }
                }
                return element
            }
            print("return dict = \(returnDict)")
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: returnDict, options: .prettyPrinted)
                print("jsondata = \(jsonData)")
                try response.status(.OK).send(data: jsonData).end()
            } catch {
                print("Error sending response")
                Log.error("Error sending response")
            }
        } else {
            do {
                try response.status(.badRequest).send("Get failed. Cannot get requested data").end()
            } catch {
                print("Error sending response")
                Log.error("Error sending response") 
            }
        }
    }





    private func convertToDocument(key: String, val: Any, fieldType: FieldType) -> (String, Value) {
        let temp: (String, Value)
        switch fieldType {
        case .int32:
            temp = (key, ~Int32(val as! Int))
            print("\(key) has int32 \(val)")
        case .int64:
            temp = (key, ~Int64(val as! Int))
            print("\(key) has int64 \(val)")
        case .binary:
            temp = (key, ~((val as! Data) as! ValueConvertible))
            print("\(key) has binary \(val)")
        case .boolean:
            temp = (key, ~(val as! Bool))
            print("\(key) has bool \(val)")
        case .dateTime:
            temp = (key, ~(val as! Date))
            print("\(key) has dateTime \(val)")
        case .double:
            temp = (key, ~(val as! Double))
            print("\(key) has double \(val)")
        case .array, .document:
            temp = (key, ~(val as! Document))
            print("\(key) has array/document \(val)")
        case .objectId:
            temp = (key, ~(val as! ObjectId))
            print("\(key) has objectID \(val)")
        case .regularExpression:
            temp = (key, ~((val as! RegularExpression) as! ValueConvertible))
            print("\(key) has regular expression \(val)")
        default:
            temp = (key, ~(val as! String))
            print("\(key) has string \(val)")
        }
        return temp
    }

    private func buildQueryWithType(dbName: String, colName: String, op: Comparison, field: String, fieldType: FieldType, value: String) -> Query? {
        let parseQuery: Query?
        do {
            switch fieldType {
            case .int32:
                let valueWithType = Int32(value)!
                parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valueWithType, comparisonOperator: op)
            case .int64:
                let valueWithType = Int64(value)!
                parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valueWithType, comparisonOperator: op)    
            case .boolean:
                let valueWithType = Bool(value)!
                try parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valueWithType, comparisonOperator: op)
            case .double:
                let valueWithType = Double(value)!
                parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valueWithType, comparisonOperator: op)
            case .document:
                let valueWithType = try Document(extendedJSON: value)
                try parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valueWithType, comparisonOperator: op)
            case .objectId:
                let valueWithType = try ObjectId(value)
                try parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valueWithType, comparisonOperator: op)
            default:
                let valueWithType = String(value)!
                parseQuery = QueryBuilder.buildQuery(fieldName: field, fieldVal: valueWithType, comparisonOperator: op)
            }
        } catch let error as FlexworkError {
            parseQuery = nil
            FlexworkError.handleError(flexworkError: error)
        } catch {
            parseQuery = nil
            Log.error("Exception when building a query document")
        }
        return parseQuery
    }

    private func getEnumComparisonType(_ op: String) -> Comparison {
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

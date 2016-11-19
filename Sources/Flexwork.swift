import MongoKitten
import Foundation
import LoggerAPI
//import Kitura

#if os(Linux)
    typealias Valuetype = Any
#else 
    typealias Valuetype = AnyObject
#endif

public class Flexwork {

    static let defaultMongoHost = "127.0.0.1"
    static let defaultMongoPort = UInt16(27017)
    static let defaultDatabaseName = "test_db"
    static let defaultUsername = "username"
    static let defaultPassword = "password"

    let databaseName = Flexwork.defaultDatabaseName
    let collectionName = "test_collection"

    let server: Server!

    // Find database if it is already running
    public init(_ dbConfig: DatabaseConfiguration) {
        
        var authorization: (username: String, password: String, against: String)? = nil
        guard let host = dbConfig.host,
              let port = dbConfig.port else {

                    Log.info("Host and port were not provided")
                    exit(1)
        }

        if let username = dbConfig.username, let password = dbConfig.password {
            authorization = (username: username, password: password, against: "admin")
        }

        do {
            server = try Server(at: host, port: port, using: authorization, automatically: true)
        } catch {
            print("Error: MongoDB is not available on host: \(host) and port: \(port)")
            Log.info("MongoDB is not available on host: \(host) and port: \(port)")
            exit(1)
        }
    }

    public init(database: String = Flexwork.defaultDatabaseName, host: String = Flexwork.defaultMongoHost, 
        port: UInt16 = Flexwork.defaultMongoPort, username: String = Flexwork.defaultUsername,
        password: String = Flexwork.defaultPassword) {
        
        do {
            server = try Server("mongodb://\(username):\(password)@\(host):\(port)", automatically: true)
        } catch {
            Log.info("MongoDB is not available on host: \(host) and port: \(port)")
            exit(1) 
        }
    }

    public func count(fieldName: String, fieldVal: String?) {
        
        do {
            if !server.isConnected { try server.connect() }

            let database = server[databaseName]
            let collection = database[collectionName]

            let query: Query = fieldName == fieldVal ?? "jz173"

            let count = try collection.count(matching: query)

            print("\(count) documents with \(fieldName) == \(fieldVal)")
        } catch {
            // handle exception
        }
    }

    public func delete(fieldName: String, fieldVal: String?) {

        do {
            if !server.isConnected { try server.connect() }

            let database = server[databaseName]
            let collection = database[collectionName]

            let query: Query = fieldName == fieldVal ?? "jz173"

            try collection.remove(matching: query)
        } catch {
            // handle exception
        }
    }

    public func insert(document: Document) {
        
        do {
            if !server.isConnected { try server.connect() }

            let database = server[databaseName]
            let collection = database[collectionName]

            try collection.insert(document)
        } catch {
            // handle exception
        }
    }

    public func find(fieldName: String, fieldVal: Int) {
        do {
            if !server.isConnected { try server.connect() }

            let database = server[databaseName]
            let collection = database[collectionName]

            let query: Query = fieldName <= fieldVal && "id" == "jy175"

            let docs = try collection.find(matching: query)
            for doc in docs {
                print(doc)
            }
            
        } catch {
            // handle exception
        }
    }

    // test func for QueryBuilder
    public func find_test_for_buildQuery() {
        do {
            if !server.isConnected { try server.connect() }

            let database = server[databaseName]
            let collection = database[collectionName]

            let query = QueryBuilder.buildQuery(fieldName: "id", fieldVal: "jy175") && 
                        QueryBuilder.buildQuery(fieldName: "count", fieldVal: 90)

            let docs = try collection.find(matching: query)
            for doc in docs {
                print(doc)
            }
            
        } catch {
            // handle exception
        }
    }

    public func update(fieldName: String, fieldVal: String?) {
        do {
            if !server.isConnected { try server.connect() }

            let database = server[databaseName]
            let collection = database[collectionName]

            let query: Query = fieldName == fieldVal ?? "gh84"

            let updateDoc: Document = [
                "id": "gh84",
                "count": 99999
            ]

            try collection.update(matching: query, to: updateDoc)
            
        } catch {
            // handle exception
        }
    }
}
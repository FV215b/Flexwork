import MongoKitten
import Foundation
import LoggerAPI

#if os(Linux)
    typealias Valuetype = Any
#else 
    typealias Valuetype = AnyObject
#endif

/**
 * Flexwork implements FlexworkAPI. Provides solid methods to interact with databse including 
 * count(), query(), insert(), delete() and update()
 */
public class Flexwork: FlexworkAPI {

    static let defaultMongoHost = "127.0.0.1"
    static let defaultMongoPort = UInt16(27017)
    static let defaultDatabaseName = "test_db"
    static let defaultUsername = "username"
    static let defaultPassword = "password"

    let server: Server!
    //let collectionConfigDictionary: [String: CollectionConfiguration]
    let dictionary: [String: [String: CollectionConfiguration]]

    // These two vars are used for testing only
    let databaseName = Flexwork.defaultDatabaseName
    let collectionName = "test_collection"
    
    // Find database if it is already running
    public init(_ dbConfig: DatabaseConfiguration, dictionary: [String: [String: CollectionConfiguration]]) {
        
        self.dictionary = dictionary
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
        password: String = Flexwork.defaultPassword, dictionary: [String: [String: CollectionConfiguration]]) {

        self.dictionary = dictionary
        
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

    
    public func getFieldType(databaseName: String, collectionName: String, fieldName: String) -> FieldType? {
        if let colConfig = dictionary[databaseName],
           let config = colConfig[collectionName] {
            return config.getFieldType(fieldName: fieldName)       
        } else {
            return nil
        } 
    }

    // Methods in FlexworkAPI
    public func find(databaseName: String, collectionName: String, query: Query) -> Cursor<Document> {
        do {
            let collection = getCollection(databaseName: databaseName, collectionName: collectionName)
            let docs = try collection.find(matching: query)
            return docs
        } catch {
            // handle exception
            exit(1)
        }
    }

    // Methods in FlexworkAPI
    public func insert(databaseName: String, collectionName: String, document: Document) {
        do {
            let collection = getCollection(databaseName: databaseName, collectionName: collectionName)
            try collection.insert(document)
        } catch {
            // handle exception
            exit(1)
        }
    }

    public func count(databaseName: String, collectionName: String, query: Query) -> Int {
    	do {
            let collection = getCollection(databaseName: databaseName, collectionName: collectionName)
            let count = try collection.count(matching: query)
            
            return count
        } catch {
            // TODO: handle exception
            exit(1);
        }
    }   

    public func delete(databaseName: String, collectionName: String, query: Query) {
        do {
            let collection = getCollection(databaseName: databaseName, collectionName: collectionName)
            try collection.remove(matching: query)
            
        } catch {
            // TODO: handle exception  
            exit(1)
        }
    }

    public func update(databaseName: String, collectionName: String, query: Query, document: Document) {
        do {
            let collection = getCollection(databaseName: databaseName, collectionName: collectionName)
            try collection.update(matching: query, to: document)
        } catch {
            // TODO: handle exception
            exit(1)
        }
    }


    private func getCollection(databaseName: String, collectionName: String) -> MongoKitten.Collection {
        do {
            if !server.isConnected { try server.connect() }
            let database = server[databaseName]
            return database[collectionName]
        } catch {
            // TODO: handle exception
            exit(1)
        }        
    }
}
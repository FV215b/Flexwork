import MongoKitten
import Foundation
import LoggerAPI

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
    let dictionary: [String: [String: CollectionConfiguration]]
    
    public init(_ dbConfig: DatabaseConfiguration, dictionary: [String: [String: CollectionConfiguration]]) {
        
        self.dictionary = dictionary
        var authorization: (username: String, password: String, against: String)? = nil
        guard let host = dbConfig.host,
              let port = dbConfig.port else {
            Log.error("Host and port were not provided")
            exit(1)
        }

        if let username = dbConfig.username, let password = dbConfig.password {
            authorization = (username: username, password: password, against: "admin")
        }

        do {
            server = try Server(at: host, port: port, using: authorization, automatically: true)
        } catch {
            print("Error: MongoDB is not available on host: \(host) and port: \(port)")
            Log.error("MongoDB is not available on host: \(host) and port: \(port)")
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
            Log.error("MongoDB is not available on host: \(host) and port: \(port)")
            exit(1) 
        }
    }

    // Methods in FlexworkAPI
    public func getFieldType(databaseName: String, collectionName: String, fieldName: String) -> FieldType? {
        if let colConfig = dictionary[databaseName],
           let config = colConfig[collectionName] {
            return config.getFieldType(fieldName: fieldName)       
        } else {
            return nil
        } 
    }

    // Methods in FlexworkAPI
    public func find(databaseName: String, collectionName: String, query: Query) -> Cursor<Document>? {
        do {
            let collection = try getCollection(databaseName: databaseName, collectionName: collectionName)
            let docs = try collection.find(matching: query)
            return docs
        } catch {
            Log.error("Error when querying the collection: \(collectionName) in database: \(databaseName)")
            return nil
        }
    }

    // Methods in FlexworkAPI
    public func insert(databaseName: String, collectionName: String, document: Document) {
        do {
            let collection = try getCollection(databaseName: databaseName, collectionName: collectionName)
            try collection.insert(document)
        } catch {
            Log.error("Error when inserting document into the collection: \(collectionName) in database: \(databaseName)")
        }
    }

    // Methods in FlexworkAPI
    public func count(databaseName: String, collectionName: String, query: Query) -> Int? {
    	do {
            let collection = try getCollection(databaseName: databaseName, collectionName: collectionName)
            let count = try collection.count(matching: query)
            return count
        } catch {
            Log.error("Error when counting document in the collection: \(collectionName) in database: \(databaseName)")
            return nil
        }
    }   

    // Methods in FlexworkAPI
    public func delete(databaseName: String, collectionName: String, query: Query) {
        do {
            let collection = try getCollection(databaseName: databaseName, collectionName: collectionName)
            try collection.remove(matching: query)
        } catch {
            Log.error("Error when deleting document in the collection: \(collectionName) in database: \(databaseName)")
        }
    }

    // Methods in FlexworkAPI
    public func update(databaseName: String, collectionName: String, query: Query, document: Document) {
        do {
            let collection = try getCollection(databaseName: databaseName, collectionName: collectionName)
            try collection.update(matching: query, to: document)
        } catch {
            Log.error("Error when updating document in the collection: \(collectionName) in database: \(databaseName)")
        }
    }

    func getCollection(databaseName: String, collectionName: String) throws -> MongoKitten.Collection {
        do {
            if !server.isConnected { try server.connect() }
            let database = server[databaseName]
            return database[collectionName]
        } 
    }
}

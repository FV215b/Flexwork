import MongoKitten
import Foundation
import LoggerAPI

public class MongoDatabase {

    static let defaultDatabaseName = "default_database"
    
    let database: Database!

    public init(_ server: Server, databaseName: String = MongoDatabase.defaultDatabaseName) {
        print("initialize database: \(databaseName)")
        database = server[databaseName]
    }
}
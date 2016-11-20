import MongoKitten
import Foundation
//import LoggerAPI
public protocol FlexworkAPI {
    
    func count(databaseName: String, collectionName: String, query: Query) -> Int
    func delete(databaseName: String, collectionName: String, query: Query)

    func insert(databaseName: String, collectionName: String, document: Document)
    func find(databaseName: String, collectionName: String, query: Query) -> Cursor<Document> 

    func update(databaseName: String, collectionName: String, query: Query, document: Document)

    func getFieldType(databaseName: String, collectionName: String, fieldName: String) -> FieldType?
}
import MongoKitten
import Foundation
//import LoggerAPI

public protocol FlexworkAPI {
    
    func count(collectionName: String, query: Query) -> Int
    func delete(collectionName: String, query: Query)
    func insert(collectionName: String, document: Document)
    func find(collectionName: String, query: Query) -> Cursor<Document> 
    func update(collectionName: String, query: Query, document: Document)
}
import MongoKitten
import Foundation

public class QueryBuilder {

    // We need bunch of overloaded buildQuery() because fieldVal could have different types
    static func buildQuery(fieldName: String, fieldVal: String?) -> Query {
        let query: Query = fieldName == fieldVal ?? "defaultVal"
        return query
    }   

    static func buildQuery(fieldName: String, fieldVal: Int) -> Query {
        let query: Query = fieldName == fieldVal
        return query
    }
}
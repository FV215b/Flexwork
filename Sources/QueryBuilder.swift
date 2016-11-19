import MongoKitten
import Foundation

enum Comparison {
    case lessThan
    case lessThanOrEqualTo
    case equalTo
    case greaterThan
    case greaterThanOrEqualTo
    case notEqualTo
}

public class QueryBuilder {

    // We need bunch of overloaded buildQuery() because fieldVal could have different types
    static func buildQuery(fieldName: String, fieldVal: String, comparisonOperator: Comparison) -> Query {
        //let query: Query = fieldName == fieldVal ?? "defaultVal"
        //return query
        switch comparisonOperator {
        case Comparison.lessThan:
            return fieldName < fieldVal
        case Comparison.lessThanOrEqualTo:
            return fieldName <= fieldVal
        case Comparison.equalTo:
            return fieldName == fieldVal
        case Comparison.greaterThan:
            return fieldName > fieldVal
        case Comparison.greaterThanOrEqualTo:
            return fieldName >= fieldVal
        case Comparison.notEqualTo:
            return fieldName != fieldVal
        //default:
            // TODO: should throw an exception.
            //return fieldName == fieldVal 
        }
    }   

    static func buildQuery(fieldName: String, fieldVal: Int, comparisonOperator: Comparison) -> Query {
        //let query: Query = fieldName == fieldVal
        //return query
        //return fieldName == fieldVal
        switch comparisonOperator {
        case Comparison.lessThan:
            return fieldName < fieldVal
        case Comparison.lessThanOrEqualTo:
            return fieldName <= fieldVal
        case Comparison.equalTo:
            return fieldName == fieldVal
        case Comparison.greaterThan:
            return fieldName > fieldVal
        case Comparison.greaterThanOrEqualTo:
            return fieldName >= fieldVal
        case Comparison.notEqualTo:
            return fieldName != fieldVal
        //default:
            // TODO: should throw an exception.
            //return fieldName == fieldVal 
        }
    }
}
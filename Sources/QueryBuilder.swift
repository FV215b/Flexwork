import MongoKitten
import Foundation

/**
 * Define operation types: <, <=, ==, >, >=, !=
 */
enum Comparison {
    case lessThan
    case lessThanOrEqualTo
    case equalTo
    case greaterThan
    case greaterThanOrEqualTo
    case notEqualTo
}

/**
 * QueryBuilder is used for returning the query rule based on the input params. For now, flexwork can be queried with 4 value 
 * type: Int, String, Double, Bool. Because it only makes sense to do the comparison with few types. Maybe we will support
 * other types (like Date) later, depending on our schedule.
 */
public class QueryBuilder {

    static func buildQuery(fieldName: String, fieldVal: String, comparisonOperator: Comparison) -> Query {
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
        }
    }   

    static func buildQuery(fieldName: String, fieldVal: Int, comparisonOperator: Comparison) -> Query {
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
        }
    }

    static func buildQuery(fieldName: String, fieldVal: Double, comparisonOperator: Comparison) -> Query {
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
        }
    }

    static func buildQuery(fieldName: String, fieldVal: Bool, comparisonOperator: Comparison) -> Query {
        switch comparisonOperator {
        case Comparison.equalTo:
            return fieldName == fieldVal
        case Comparison.notEqualTo:
            return fieldName != fieldVal
        default:
            // make it return something for now. Should revise later
            // TODO: throw exception
            return fieldName == fieldVal
        }
    }
}
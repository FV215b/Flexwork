import MongoKitten
import Foundation

/**
 * QueryBuilder is used for returning the query rule based on the input params. For now, flexwork can be queried with 4 value 
 * type: Int, String, Double, Bool. Because it only makes sense to do the comparison with few types. Maybe we will support
 * other types (like Date) later, depending on our schedule.
 */
public class QueryBuilder {

    static let errorMsg = "Cannot apply the comparison on this field type"

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

    static func buildQuery(fieldName: String, fieldVal: Bool, comparisonOperator: Comparison) throws -> Query {
        switch comparisonOperator {
        case Comparison.equalTo:
            return fieldName == fieldVal
        case Comparison.notEqualTo:
            return fieldName != fieldVal
        default:
            // throw an exception, cuz other type of comparison is not allowded on Bool
            throw FlexworkError.comparisonNotAllowdedError(errorMsg)
        }
    }
}
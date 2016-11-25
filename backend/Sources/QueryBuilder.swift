import MongoKitten
import Foundation

/**
 * QueryBuilder is used for returning the query rule based on the input params.
 * Comparison is allowed in following FieldType: .string, int32, int64, double,
 * boolean, document and objectId
 */
public class QueryBuilder {

    static let errorMsg = "Cannot apply the comparison on this field type"

    // Overloaded func for FieldType.string
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

    // Overloaded func for FieldType.int32
    static func buildQuery(fieldName: String, fieldVal: Int32, comparisonOperator: Comparison) -> Query {
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

    // Overloaded func for FieldType.int64
    static func buildQuery(fieldName: String, fieldVal: Int64, comparisonOperator: Comparison) -> Query {
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

    // Overloaded func for FieldType.double
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

    // Overloaded func for FieldType.boolean
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

    // Overloaded func for FieldType.document
    static func buildQuery(fieldName: String, fieldVal: Document, comparisonOperator: Comparison) throws -> Query {
        switch comparisonOperator {
        case Comparison.equalTo:
            return fieldName == fieldVal
        case Comparison.notEqualTo:
            return fieldName != fieldVal
        default:
            // throw an exception, cuz other type of comparison is not allowded on Document
            throw FlexworkError.comparisonNotAllowdedError(errorMsg)
        }
    }

    // Overloaded func for FieldType.objectId
    static func buildQuery(fieldName: String, fieldVal: ObjectId, comparisonOperator: Comparison) throws -> Query {
        switch comparisonOperator {
        case Comparison.equalTo:
            return fieldName == fieldVal
        case Comparison.notEqualTo:
            return fieldName != fieldVal
        default:
            // throw an exception, cuz other type of comparison is not allowded on ObjectId
            throw FlexworkError.comparisonNotAllowdedError(errorMsg)
        }
    }    
}
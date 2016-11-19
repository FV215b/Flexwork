import Foundation

/**
* CollectionConfiguration mainly defines the field needed for querying. Because the framework is intended to
* be generic, so we cannot know the type of field in advance. However, querying the field requires knowing the 
* type of the field, so we just provide this class for developers to map the field to field type.
*
* Only the field used for defining query rules needed to be included.
*/

enum FieldType {
    case int
    case boolean
    case double
    case string
}

public class CollectionConfiguration {

    var name = "test_collection"
    var queryFieldType = [String: FieldType]()

    init(collectionName: String) {
        self.name = collectionName
    }

    func addNewFieldType(fieldName: String, type: FieldType) {
        queryFieldType[fieldName] = type
    }
}
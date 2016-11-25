
#if os(Linux)
    typealias Valuetype = Any
#else 
    typealias Valuetype = AnyObject
#endif

/**
 * BSON value type stored in MongoDB for each field.
 */
public enum FieldType {
    // case int
    // case bool
    // case double
    // case string
    case double                     // 64 bit binary floating point
    case string                     // UTF-8 string
    case document                   // embedded document
    case array                      // Array
    case binary                     // Binary data
    case objectId                   // [ObjectId](http://dochub.mongodb.org/core/objectids)
    case boolean                    // Boolean (true or false)
    case dataTime                   // UTC DateTime
    case null                       // Null value
    case int32                      // 32-bit integer
    case int64                      // 64-bit integer
}

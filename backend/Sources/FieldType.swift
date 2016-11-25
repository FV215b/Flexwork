
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
    case regularExpression          // Regular expression with regex pattern and options string. Options are identified by characters, which must be stored in alphabetical order. Valid options are 'i' for case insensitive matching, 'm' for multiline matching, 'x' for verbose mode, 'l' to make \w, \W, etc. locale dependent, 's' for dotall mode ('.' matches everything), and 'u' to make \w, \W, etc. match unicode.
    case javascriptCode             // JavaScript code
    case javascriptCodeWithScope    // JavaScript code w/ scope
    case int32                      // 32-bit integer
    case timestamp                  // MongoBD internal timestamp type
    case int64                      // 64-bit integer
}

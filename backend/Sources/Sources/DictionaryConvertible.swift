import Foundation

typealias JSONDictionary = [String: Any]

protocol DictionaryConvertible {
    func toDictionary() -> JSONDictionary
}
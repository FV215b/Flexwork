import Foundation
import LoggerAPI

public enum FlexworkError: Error {
    case comparisonNotAllowdedError(String)
    case collectionNotExistError(String)

    static func handleError(flexworkError error: FlexworkError) {
        switch error {
            case .comparisonNotAllowdedError(let msg):
                Log.error(msg)
            case .collectionNotExistError(let msg):
                Log.error(msg)
        }
    }
}
import Foundation
import MongoKitten
import XCTest

@testable import Flexwork

class TestFlexwork: XCTestCase {

    let databaseName = "test_db"
    let collectionName = "test_collection"
    let fieldName_1 = "id"
    let fieldType_1 = FieldType.string
    let fieldName_2 = "count"
    let fieldType_2 = FieldType.int32
    // let collectionConfig = CollectionConfiguration(collectionName: collectionName)
    // collectionConfig.addNewFieldType(fieldName: fieldName_1, type: fieldType_1)
    // collectionConfig.addNewFieldType(fieldName: fieldName_2, type: fieldType_2)
    //let dictionary// = [databaseName: [collectionName: collectionConfig]]

    let dbConfig = DatabaseConfiguration(host: "54.91.87.59", port: UInt16(27017), username: nil, password: nil)

    static var allTests: [(String, (TestFlexwork) -> () throws -> Void)] {
        return [
            ("testGetFieldType", testGetFieldType)
        ]
    }

    var flexwork: Flexwork?

    override func setUp() {
        // let databaseName = "test_db"
        // let collectionName = "test_collection"
        // let fieldName_1 = "id"
        // let fieldType_1 = FieldType.string
        // let fieldName_2 = "count"
        // let fieldType_2 = FieldType.int32
        let collectionConfig = CollectionConfiguration(collectionName: collectionName)
        collectionConfig.addNewFieldType(fieldName: fieldName_1, type: fieldType_1)
        collectionConfig.addNewFieldType(fieldName: fieldName_2, type: fieldType_2)
        let dictionary = [databaseName: [collectionName: collectionConfig]]
        flexwork = Flexwork(dbConfig, dictionary: dictionary)
        super.setUp()
    }

    func testGetFieldType() {

        guard let flexwork = flexwork else {
            XCTFail()
            return
        }

        // let expectation1 = expectation(description: "Get fieldType")

        let fieldType1_optional = flexwork.getFieldType(databaseName: databaseName, collectionName: collectionName, fieldName: fieldName_1)
        guard let fieldType1 = fieldType1_optional else {
            XCTFail()
            return
        }

        let fieldType2_optional = flexwork.getFieldType(databaseName: databaseName, collectionName: collectionName, fieldName: fieldName_2)
        guard let fieldType2 = fieldType2_optional else {
            XCTFail()
            return
        }

        XCTAssertEqual(fieldType1, fieldType_1)
        XCTAssertEqual(fieldType2, fieldType_2)
        // expectation1.fulfill()
    }
}
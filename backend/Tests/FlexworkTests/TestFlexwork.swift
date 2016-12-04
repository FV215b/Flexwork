import Foundation
import MongoKitten
import XCTest

@testable import Flexwork

/**
 * Testing framework for Flexwork.
 * Currently there is an internal bug in swift on Linux. If you want to execute the test by "swift test",
 * remember to remove the "main.swift" in Sources directory.
 * For more info about the bug: https://bugs.swift.org/browse/SR-1503
 */
class TestFlexwork: XCTestCase {

    let databaseName = "test_db"
    let collectionName = "test_collection"
    let fieldName_1 = "id"
    let fieldType_1 = FieldType.string
    let fieldName_2 = "count"
    let fieldType_2 = FieldType.int64
    
    static var allTests: [(String, (TestFlexwork) -> () throws -> Void)] {
        return [
            ("testGetFieldType", testGetFieldType),
            ("testInsertDocument", testInsertDocument)
        ]
    }

    var flexwork: Flexwork?

    override func setUp() {
        let collectionConfig = CollectionConfiguration(collectionName: collectionName)
        collectionConfig.addNewFieldType(fieldName: fieldName_1, type: fieldType_1)
        collectionConfig.addNewFieldType(fieldName: fieldName_2, type: fieldType_2)
        let dictionary = [databaseName: [collectionName: collectionConfig]]
        let dbConfig = DatabaseConfiguration(host: "54.86.5.24", port: UInt16(27017), username: nil, password: nil)
        flexwork = Flexwork(dbConfig, dictionary: dictionary)
        super.setUp()
    }

    func testGetFieldType() {

        guard let flexwork = flexwork else {
            XCTFail()
            return
        }

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
    }

    func testInsertDocument() {

        guard let flexwork = flexwork else {
            XCTFail()
            return
        }

        let testDoc: Document = [
            fieldName_1: "test_id",
            fieldName_2: 100
        ]

        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc)
        
        let query = QueryBuilder.buildQuery(fieldName: fieldName_1, fieldVal: "test_id", comparisonOperator: .equalTo) &&
                    QueryBuilder.buildQuery(fieldName: fieldName_2, fieldVal: Int64(100), comparisonOperator: .equalTo)
        let cursor_opt = flexwork.find(databaseName: databaseName, collectionName: collectionName, query: query)
        guard let cursor = cursor_opt else {
            XCTFail()
            return
        }
        
        var count = 0
        for _ in cursor {
            count += 1
        }
        XCTAssertEqual(count, 1)
    }
}
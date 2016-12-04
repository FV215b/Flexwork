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
            ("testInsertDocument", testInsertDocument),
            ("testFindDocument", testFindDocument),
            ("testCountDocument", testCountDocument),
            ("testDeleteDocument", testDeleteDocument)
        ]
    }

    var flexwork_opt: Flexwork?

    override func setUp() {
        let collectionConfig = CollectionConfiguration(collectionName: collectionName)
        collectionConfig.addNewFieldType(fieldName: fieldName_1, type: fieldType_1)
        collectionConfig.addNewFieldType(fieldName: fieldName_2, type: fieldType_2)
        let dictionary = [databaseName: [collectionName: collectionConfig]]
        let dbConfig = DatabaseConfiguration(host: "54.86.5.24", port: UInt16(27017), username: nil, password: nil)
        flexwork_opt = Flexwork(dbConfig, dictionary: dictionary)
        super.setUp()
    }

    override func tearDown() {
        guard let flexwork = flexwork_opt else {
            XCTFail()
            exit(1)
        }

        // drop test_collection after testing. Cuz the existing data in the test_collection may compromise the later test.
        do {
            let collection = try flexwork.getCollection(databaseName: self.databaseName, collectionName: self.collectionName)
            try collection.drop()
        } catch {
            XCTFail()
            exit(1)
        }
        super.tearDown()  
    }

    // Unit test for getFieldType()
    func testGetFieldType() {

        guard let flexwork = flexwork_opt else {
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

    // Unit test for insert()
    func testInsertDocument() {

        guard let flexwork = flexwork_opt else {
            XCTFail()
            return
        }

        let testDoc: Document = [
            fieldName_1: "test_insert",
            fieldName_2: 100
        ]

        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc)
        
        // construct a query with every field == field value inserted before.
        let query = QueryBuilder.buildQuery(fieldName: fieldName_1, fieldVal: "test_insert", comparisonOperator: .equalTo) &&
                    QueryBuilder.buildQuery(fieldName: fieldName_2, fieldVal: Int64(100), comparisonOperator: .equalTo)
        let cursor_opt = flexwork.find(databaseName: databaseName, collectionName: collectionName, query: query)
        guard let cursor = cursor_opt else {
            XCTFail()
            return
        }
        
        // check if there is only one document.
        var count = 0
        for _ in cursor {
            count += 1
        }
        XCTAssertEqual(count, 1)
    }

    // Unit test for Find()
    func testFindDocument() {
        guard let flexwork = flexwork_opt else {
            XCTFail()
            return
        }

        let testDoc1: Document = [
            fieldName_1: "test_find",
            fieldName_2: 90
        ]

        let testDoc2: Document = [
            fieldName_1: "test_find",
            fieldName_2: 89
        ]

        let testDoc3: Document = [
            fieldName_1: "test_find",
            fieldName_2: 88
        ]

        // Insert three test doc into the test_collection
        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc1)
        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc2)
        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc3)

        // build a query to query the document with count value less than 91. The expected number of doc returned is 3
        let query = QueryBuilder.buildQuery(fieldName: fieldName_2, fieldVal: Int64(91), comparisonOperator: .lessThan) &&
                    QueryBuilder.buildQuery(fieldName: fieldName_1, fieldVal: "test_find", comparisonOperator: .equalTo)
        let cursor_opt = flexwork.find(databaseName: databaseName, collectionName: collectionName, query: query)
        guard let cursor = cursor_opt else {
            XCTFail()
            return
        }
        
        // check if there is only one document.
        var count = 0
        for _ in cursor {
            count += 1
        }
        XCTAssertEqual(count, 3)
    }

    // Unit test for count()
    func testCountDocument() {
        guard let flexwork = flexwork_opt else {
            XCTFail()
            return
        }

        let testDoc1: Document = [
            fieldName_1: "test_count",
            fieldName_2: 90
        ]

        let testDoc2: Document = [
            fieldName_1: "test_count",
            fieldName_2: 89
        ]

        let testDoc3: Document = [
            fieldName_1: "test_count",
            fieldName_2: 88
        ]

        // insert the test document into the test_collection
        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc1)
        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc2)
        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc3)

        // build a query to query the document with id equal to "test_count". The expected number of doc returned is 3
        let query = QueryBuilder.buildQuery(fieldName: fieldName_1, fieldVal: "test_count", comparisonOperator: .equalTo)
        let cursor_opt = flexwork.find(databaseName: databaseName, collectionName: collectionName, query: query)
        guard let cursor = cursor_opt else {
            XCTFail()
            return
        }
        
        // check if there is only one document.
        var count = 0
        for _ in cursor {
            count += 1
        }
        XCTAssertEqual(count, 3)
    }

    // Unit test for delete()
    func testDeleteDocument() {
        guard let flexwork = flexwork_opt else {
            XCTFail()
            return
        }

        let testDoc: Document = [
            fieldName_1: "test_delete",
            fieldName_2: 90
        ]

        // insert the test document into the test_collection
        flexwork.insert(databaseName: databaseName, collectionName: collectionName, document: testDoc)        
        // build a query to query the document with id equal to "test_delete". The expected number of doc returned is 1
        // just make sure we insert the document into the collection successfully
        let query = QueryBuilder.buildQuery(fieldName: fieldName_1, fieldVal: "test_delete", comparisonOperator: .equalTo)
        var cursor_opt = flexwork.find(databaseName: databaseName, collectionName: collectionName, query: query)
        guard let cursor = cursor_opt else {
            XCTFail()
            return
        }

        var count = 0
        for _ in cursor {
            count += 1
        }
        XCTAssertEqual(count, 1)

        // delete the testDoc
        flexwork.delete(databaseName: databaseName, collectionName: collectionName, query: query)
        // do the same query again. This time the expected number of doc returned is 0
        cursor_opt = flexwork.find(databaseName: databaseName, collectionName: collectionName, query: query)
        guard let cursor_2 = cursor_opt else {
            XCTFail()
            return
        }

        count = 0
        for _ in cursor_2 {
            count += 1
        }
        XCTAssertEqual(count, 0)
    }
}
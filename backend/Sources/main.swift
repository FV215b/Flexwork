// print("Hello, world!")

// let mongoConfig = MongoConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

// let mongoClient = MongoClient(mongoConfig)
//let mongoClient = MongoClient(host: "127.0.0.1", port: UInt16(27017), username: "test", password: "1234")

// let mongoDatabase = mongoClient["test_database"]
// print("Test Finished!")
import Kitura
import MongoKitten

let databaseName = "test_db"

/*
let collectionName_1 = "test_collection"
let fieldName_1 = "id"
let fieldType_1 = FieldType.string
let fieldName_2 = "count"
let fieldType_2 = FieldType.int32
let collectionConfig_1 = CollectionConfiguration(collectionName: collectionName_1)
collectionConfig_1.addNewFieldType(fieldName: fieldName_1, type: fieldType_1)
collectionConfig_1.addNewFieldType(fieldName: fieldName_2, type: fieldType_2)

let collectionName_2 = "test_collection2"
let collectionConfig_2 = CollectionConfiguration(collectionName: collectionName_2)

let dictionary = [databaseName: [collectionName_1: collectionConfig_1, collectionName_2: collectionConfig_2]]

let dbConfig = DatabaseConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

let flexwork = Flexwork(dbConfig, dictionary: dictionary)

let doc: Document = [
    "id": "gh84",
    "count": 66
]

// flexwork.test_insert(doc: doc)

let controller = FlexworkController(backend: flexwork)

Kitura.addHTTPServer(onPort: 8090, with: controller.router)

Kitura.run()
*/

/*
print("Test Begin!")

let dbConfig = DatabaseConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)
let flexwork = Flexwork(dbConfig)

flexwork.count(fieldName: "id", fieldVal: "jz173")
flexwork.count(fieldName: "id", fieldVal: "jy175")
flexwork.count(fieldName: "id", fieldVal: "gh84")
flexwork.count(fieldName: "id", fieldVal: "jz173")

print("delete document with id == gh84")
flexwork.delete(fieldName: "id", fieldVal: "gh84")
flexwork.count(fieldName: "id", fieldVal: "gh84")

print("insert document with id == gh84")
let doc: Document = [
    "id": "gh84",
    "count": 66
]
flexwork.insert(document: doc)
flexwork.count(fieldName: "id", fieldVal: "gh84")

flexwork.find(fieldName: "count", fieldVal: 90)

flexwork.update(fieldName: "id", fieldVal: "gh84")
print("*************find_test_for_buildQuery****************")
flexwork.find_test_for_buildQuery()

print("*************test_create_collection_by_name***********")
flexwork.createCollection(name: "aspofdpsaofdjposajdfpojsafd", document: doc)

print("Test Finish!")
*/

let collectionName_1 = "test_collection"
let fieldName_1 = "id"
let fieldType_1 = FieldType.string
let fieldName_2 = "count"
let fieldType_2 = FieldType.int32
let collectionConfig_1 = CollectionConfiguration(collectionName: collectionName_1)
collectionConfig_1.addNewFieldType(fieldName: fieldName_1, type: fieldType_1)
collectionConfig_1.addNewFieldType(fieldName: fieldName_2, type: fieldType_2)

let collectionName_2 = "test_collection2"
let collectionConfig_2 = CollectionConfiguration(collectionName: collectionName_2)

let dictionary = [databaseName: [collectionName_1: collectionConfig_1, collectionName_2: collectionConfig_2]]

let dbConfig = DatabaseConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

let flexwork = Flexwork(dbConfig, dictionary: dictionary)

let doc: Document = [
    "id": "gh84",
    "count": 66
]

// flexwork.test_insert(doc: doc)

let controller = FlexworkController(backend: flexwork)

Kitura.addHTTPServer(onPort: 8090, with: controller.router)

Kitura.run()
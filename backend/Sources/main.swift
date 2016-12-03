// print("Hello, world!")

// let mongoConfig = MongoConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

// let mongoClient = MongoClient(mongoConfig)
//let mongoClient = MongoClient(host: "127.0.0.1", port: UInt16(27017), username: "test", password: "1234")

// let mongoDatabase = mongoClient["test_database"]
// print("Test Finished!")
import Kitura
import MongoKitten

let databaseName = "test_db"

let collectionName_1 = "veggies_info"
let fieldName_1 = "name"
let fieldType_1 = FieldType.string
let fieldName_2 = "team"
let fieldType_2 = FieldType.string
let fieldName_3 = "age"
let fieldType_3 = FieldType.int32
let collectionConfig_1 = CollectionConfiguration(collectionName: collectionName_1)
collectionConfig_1.addNewFieldType(fieldName: fieldName_1, type: fieldType_1)
collectionConfig_1.addNewFieldType(fieldName: fieldName_2, type: fieldType_2)
collectionConfig_1.addNewFieldType(fieldName: fieldName_3, type: fieldType_3)

let collectionName_2 = "test_collection2"
let collectionConfig_2 = CollectionConfiguration(collectionName: collectionName_2)

let collectionName_3 = "test_collection"
let fieldName_3_1 = "id"
let fieldType_3_1 = FieldType.string
let fieldName_3_2 = "count"
let fieldType_3_2 = FieldType.int32
let collectionConfig_3 = CollectionConfiguration(collectionName: collectionName_3)
collectionConfig_3.addNewFieldType(fieldName: fieldName_3_1, type: fieldType_3_1)
collectionConfig_3.addNewFieldType(fieldName: fieldName_3_2, type: fieldType_3_2)

let dictionary = [databaseName: [collectionName_1: collectionConfig_1, collectionName_2: collectionConfig_2, collectionName_3: collectionConfig_3]]

let dbConfig = DatabaseConfiguration(host: "52.87.158.72", port: UInt16(27017), username: nil, password: nil)

let flexwork = Flexwork(dbConfig, dictionary: dictionary)

let controller = FlexworkController(backend: flexwork)

Kitura.addHTTPServer(onPort: 8090, with: controller.router)

Kitura.run()
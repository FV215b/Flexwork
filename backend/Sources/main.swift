// print("Hello, world!")

// let mongoConfig = MongoConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

// let mongoClient = MongoClient(mongoConfig)
//let mongoClient = MongoClient(host: "127.0.0.1", port: UInt16(27017), username: "test", password: "1234")

// let mongoDatabase = mongoClient["test_database"]
// print("Test Finished!")
import Kitura
import MongoKitten

let databaseName_1 = "veggies_info_db"

let collectionName_1 = "test_collection_1"
let collectionConfig_1 = CollectionConfiguration(collectionName: collectionName_1)

let collectionName_2 = "veggies_info_collection"
let collectionConfig_2 = CollectionConfiguration(collectionName: collectionName_2)
let fieldName_21 = "name"
let fieldType_21 = FieldType.string
let fieldName_22 = "netID"
let fieldType_22 = FieldType.string
let fieldName_23 = "gender"
let fieldType_23 = FieldType.boolean
let fieldName_24 = "team"
let fieldType_24 = FieldType.string
let fieldName_25 = "height"
let fieldType_25 = FieldType.string
let fieldName_26 = "city"
let fieldType_26 = FieldType.string
let fieldName_27 = "languages"
let fieldType_27 = FieldType.array
let fieldName_28 = "hobbies"
let fieldType_28 = FieldType.array
let fieldName_29 = "degree"
let fieldType_29 = FieldType.string
collectionConfig_2.addNewFieldType(fieldName: fieldName_21, type: fieldType_21)
collectionConfig_2.addNewFieldType(fieldName: fieldName_22, type: fieldType_22)
collectionConfig_2.addNewFieldType(fieldName: fieldName_23, type: fieldType_23)
collectionConfig_2.addNewFieldType(fieldName: fieldName_24, type: fieldType_24)
collectionConfig_2.addNewFieldType(fieldName: fieldName_25, type: fieldType_25)
collectionConfig_2.addNewFieldType(fieldName: fieldName_26, type: fieldType_26)
collectionConfig_2.addNewFieldType(fieldName: fieldName_27, type: fieldType_27)
collectionConfig_2.addNewFieldType(fieldName: fieldName_28, type: fieldType_28)
collectionConfig_2.addNewFieldType(fieldName: fieldName_29, type: fieldType_29)

let databaseName_2 = "test_db"
let collectionName_3 = "test_collection"
let collectionConfig_3 = CollectionConfiguration(collectionName: collectionName_3)
let fieldName_31 = "id"
let fieldType_31 = FieldType.string
let fieldName_32 = "count"
let fieldType_32 = FieldType.int32
collectionConfig_3.addNewFieldType(fieldName: fieldName_31, type: fieldType_31)
collectionConfig_3.addNewFieldType(fieldName: fieldName_32, type: fieldType_32)

let dictionary = [databaseName_1: [collectionName_1: collectionConfig_1, collectionName_2: collectionConfig_2], databaseName_2: [collectionName_3: collectionConfig_3]]

let dbConfig = DatabaseConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

let flexwork = Flexwork(dbConfig, dictionary: dictionary)

let controller = FlexworkController(backend: flexwork)

Kitura.addHTTPServer(onPort: 8090, with: controller.router)

Kitura.run()

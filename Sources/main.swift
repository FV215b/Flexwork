// print("Hello, world!")

// let mongoConfig = MongoConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

// let mongoClient = MongoClient(mongoConfig)
//let mongoClient = MongoClient(host: "127.0.0.1", port: UInt16(27017), username: "test", password: "1234")

// let mongoDatabase = mongoClient["test_database"]
// print("Test Finished!")
import Kitura
import MongoKitten

//let flexwork = Flexwork()
//let controller = FlexworkController(backend: flexwork)

//Kitura.addHTTPServer(onPort: 8090, with: controller.router)

//Kitura.run()

print("Test Begin!")

let dbConfig = DatabaseConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)
let flexwork = Flexwork(dbConfig)

flexwork.count(fieldName: "id", fieldVal: "jz173")
flexwork.count(fieldName: "id", fieldVal: "jy175")
flexwork.count(fieldName: "id", fieldVal: "gh84")

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

print("Test Finish!")
print("Hello, world!")

let mongoConfig = MongoConfiguration(host: "127.0.0.1", port: UInt16(27017), username: nil, password: nil)

let mongoClient = MongoClient(mongoConfig)
//let mongoClient = MongoClient(host: "127.0.0.1", port: UInt16(27017), username: "test", password: "1234")

let mongoDatabase = mongoClient["test_database"]
print("Test Finished!")

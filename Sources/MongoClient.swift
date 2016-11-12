import MongoKitten
import Foundation
import LoggerAPI

#if os(Linux)
    typealias Valuetype = Any
#else 
    typealias Valuetype = AnyObject
#endif

public class MongoClient {
    
    static let defaultMongoHost = "127.0.0.1"
    static let defaultMongoPort = UInt16(27017)
    static let defaultUsername = "test"
    static let defaultPassword = "1234"

    let server: Server!

// init MongoClient with provided config
    public init(_ mongoConfig: MongoConfiguration) {

        var authorization: (username: String, password: String, against: String)? = nil

        guard let host = mongoConfig.host,
              let port = mongoConfig.port else {
                  Log.info("Host and port are not provided")
                  exit(1)
            }
        
        if let username = mongoConfig.username, let password = mongoConfig.password {
            authorization = (username: username, password: password, against: "admin")
        }

        do {
            server = try Server(at: host, port: port, using: authorization, automatically: true)
            //print("MongoDB server on host: \(host) and port: \(port) is connected!")     
        } catch {
            //print("MongoDB is not available on host: \(host) and port: \(port)")
            Log.info("MongoDB is not available on host: \(host) and port: \(port)")
            exit(1)
        }
    }

    // init MongoClient with default or manually input host, port, username and password.
    public init(host: String = MongoClient.defaultMongoHost, port: UInt16 = MongoClient.defaultMongoPort, 
        username: String = MongoClient.defaultUsername, password: String = MongoClient.defaultPassword) {
        
        do {
            server = try Server("mongodb://\(username):\(password)@\(host):\(port)", automatically: true)
            //print("MongoDB server on host: \(host) and port: \(port) is connected!")
        } catch {
            //print("MongoDB is not available on host: \(host) and port: \(port)")
            Log.info("MongoDB is not available on the given host: \(host) and port: \(port)")
            exit(1)
        }
    }
}
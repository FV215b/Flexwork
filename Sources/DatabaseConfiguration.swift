import Foundation

public struct DatabaseConfiguration {

    var host: String?
    var port: UInt16?
    var username: String?
    var password: String?
    
    public init(host: String?, port: UInt16?, username: String?, password: String?) {
        self.host = host
        self.port = port
        self.username = username
        self.password = password
    }
}
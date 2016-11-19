import Foundation

public struct DatabaseConfiguration {

    public var host: String?
    public var port: UInt16?
    public var username: String?
    public var password: String?
    
    public init(host: String?, port: UInt16?, username: String?, password: String?) {
        self.host = host
        self.port = port
        self.username = username
        self.password = password
    }
}
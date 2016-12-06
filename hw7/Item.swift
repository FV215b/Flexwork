//
//  item.swift
//  WEEK3
//
//  Created by Yuchen Zhou on 9/20/16.
//  Copyright © 2016 Duke University. All rights reserved.
//
//  Class for person's info data model

import UIKit

// Picker view data model
enum Status {
    case other, bs, ms, meng, phD
    func description() -> String {
        switch self {
        case .other:
            return "Other"
        case .bs:
            return "B.S"
        case .ms:
            return "M.S"
        case .meng:
            return "Meng"
        case .phD:
            return "PhD"
        }
    }
}

class Item: NSObject, NSCoding {
    var name: String
    var netID: String
    var gender: Bool
    var team: String
    var height: String
    var city: String
    var status: Status
    var languages: [String]
    var hobbies: [String]
    var image: UIImage
    
    struct propertyKey {
        static let nameKey = "name"
        static let netIDKey = "netID"
        static let genderKey = "gender"
        static let teamKey = "team"
        static let heightKey = "height"
        static let cityKey = "city"
        static let statusKey = "status"
        static let languagesKey = "languages"
        static let hobbiesKey = "hobbies"
        static let imageKey = "image"
    }
    
    // Encode data when saving to file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: propertyKey.nameKey)
        aCoder.encode(netID, forKey: propertyKey.netIDKey)
        aCoder.encode(gender, forKey: propertyKey.genderKey)
        aCoder.encode(team, forKey: propertyKey.teamKey)
        aCoder.encode(height, forKey: propertyKey.heightKey)
        aCoder.encode(city, forKey: propertyKey.cityKey)
        aCoder.encode(status.description(), forKey: propertyKey.statusKey)
        aCoder.encode(languages, forKey: propertyKey.languagesKey)
        aCoder.encode(hobbies, forKey: propertyKey.hobbiesKey)
        aCoder.encode(image, forKey: propertyKey.imageKey)
    }
    
    init?(image: UIImage, name: String, netID: String, gender: Bool, team: String, height: String, city: String, status: Status, languages: [String], hobbies: [String]) {
        
        self.image = image
        self.name = name
        self.netID = netID
        self.gender = gender
        self.team = team
        self.height = height
        self.city = city
        self.status = status
        self.languages = languages
        self.hobbies = hobbies
        /*if self.name != "" && self.netID != "" && self.team != "" {
        }
        else {
            return nil
        }*/
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: propertyKey.nameKey) as! String
        let netID = aDecoder.decodeObject(forKey: propertyKey.netIDKey) as! String
        let team = aDecoder.decodeObject(forKey: propertyKey.teamKey) as! String
        //let gender = aDecoder.decodeObject(forKey: propertyKey.genderKey) as! Bool
        let gender = aDecoder.decodeBool(forKey: propertyKey.genderKey)
        let height = aDecoder.decodeObject(forKey: propertyKey.heightKey) as! String
        let city = aDecoder.decodeObject(forKey: propertyKey.cityKey) as! String
        let languages = aDecoder.decodeObject(forKey: propertyKey.languagesKey) as! [String]
        let hobbies = aDecoder.decodeObject(forKey: propertyKey.hobbiesKey) as! [String]
        let image = aDecoder.decodeObject(forKey: propertyKey.imageKey) as! UIImage
        let statusStr = aDecoder.decodeObject(forKey: propertyKey.statusKey) as! String
        let status: Status
        switch statusStr {
        case "B.S":
            status = .bs
        case "M.S":
            status = .ms
        case "Meng":
            status = .meng
        case "PhD":
            status = .phD
        default:
            status = .other
        }
        self.init(image: image, name: name, netID: netID, gender: gender, team: team, height: height, city: city, status:status, languages: languages, hobbies: hobbies)
    }
    
    // Set data save path and file name
    static let documentsDirectory = FileManager.default.urls(for: . documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = documentsDirectory.appendingPathComponent("items")
    
}

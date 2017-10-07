//
//  Model.swift
//  SmartJump
//
//  Created by Boris Chirino on 07/10/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation


struct Location {
    var lat : Double
    var long : Double
    var precision : Double
}



@objc class Station : NSObject, NSCoding {
    
    var lat : Double
    var long : Double
    var dis : Double
    var type : String
    var info : Info
    
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.lat, forKey: "lat")
        aCoder.encode(self.long, forKey: "long")
        aCoder.encode(self.dis, forKey: "dis")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.info, forKey: "info")
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
       self.lat = aDecoder.decodeDouble(forKey: "lat")
       self.long = aDecoder.decodeDouble(forKey: "long")
       self.dis = aDecoder.decodeDouble(forKey: "dis")
       self.type = aDecoder.decodeObject(forKey: "type") as! String
       self.info = aDecoder.decodeObject(forKey: "info") as! Info
    }

    
     init(la :Double, lo :Double, d: Double, t: String, i: Info) {
        lat = la
        long = lo
        dis = d
        type = t
        info = i
    }


}



@objc class Info : NSObject, NSCoding {
    var name : String
    var address : String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.address, forKey: "address")
    }
    
    
    init(name :String, address: String) {
        self.name = name
        self.address = address
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.address = aDecoder.decodeObject(forKey: "address") as! String
    }
}

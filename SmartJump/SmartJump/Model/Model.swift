//
//  Model.swift
//  SmartJump
//
//  Created by Boris Chirino on 07/10/2017.
//  Copyright © 2017 Home. All rights reserved.
//

import Foundation


class Location {
    var lat : Double
    var long : Double
    var precision : Double
}


class Station {
    var lat : Double
    var long : Double
    var dis : Double
    var type : String
    var info : Info
}



class Info {
    var name : String
    var address : String
}

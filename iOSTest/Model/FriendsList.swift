//
//  FriendsList.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import Foundation

struct FriendsList:Codable {
    var results:[Friend]?
}
struct Friend:Codable {
    var gender:String?
    var name:Name?
    var location:Location?
    var email:String?
    var phone:String?
    var cell:String?
    var picture:Picture?
    
}
struct Name:Codable {
    var title:String?
    var first:String?
    var last:String?
    var fullName:String?{
        return "\(title ?? "") \(first ?? "") \(last ?? "")"
    }
}
struct Location:Codable {
    var street:Street?
    var city:String?
    var state:String?
    var country:String?
    //var postcode:Int?

    
}
struct Street:Codable {
    var number:Int?
    var name:String?
}
struct Picture:Codable {
    var large:String?
    var medium:String?
    var thumbnail:String?
    
}


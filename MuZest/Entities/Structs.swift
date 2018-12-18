//
//  Structs.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//
import Foundation

struct UserData {
    var username: String?
    var real_name: String?
    var about: String?
    var follows: String?
    var profile_photo_url: String?
}

struct Profile {
    var username: String?
    var real_name: String?
    var about: String?
    var follow_names: Array<Substring>?
    var photo: Data?
    var follower_names: Array<Substring>?
    var post_ids: Array<Substring>?
}

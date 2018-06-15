//
//  Model.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct Room {
    
    let creator: String
    let members: [String]
    let questions: [String]
    let code: String
    let state: String
    let date: Int
    let title: String
    
    var dictionary: [String: Any] {
        return [
            "creator": creator,
            "members": members,
            "questions": questions,
            "code": code,
            "state": state,
            "date": date,
            "title": title
        ]
    }
}

struct User {
    let firebaseInstanceId: String
    let name: String
    let photoUrl: String
    
    var dictionary: [String: Any] {
        return [
            FirebaseConstant.USERS_KEY_FIREBASE_ID: firebaseInstanceId,
            FirebaseConstant.USERS_KEY_NAME: name,
            FirebaseConstant.USERS_KEY_PHOTO: photoUrl
        ]
    }
}

extension User: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let name = dictionary[FirebaseConstant.USERS_KEY_NAME] as? String,
            let photoUrl = dictionary[FirebaseConstant.USERS_KEY_PHOTO] as? String,
            let firebaseInstanceId = dictionary[FirebaseConstant.USERS_KEY_FIREBASE_ID] as? String
            else { return nil }
        
        self.init(firebaseInstanceId: firebaseInstanceId, name: name, photoUrl: photoUrl)
    }
}

extension Room: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard
            let creator = dictionary["creator"] as? String,
            let members = dictionary["members"] as? [String],
            let questions = dictionary["questions"] as? [String],
            let code = dictionary["code"] as? String,
            let state = dictionary["state"] as? String,
            let date = dictionary["date"] as? Int,
            let title = dictionary["title"] as? String
            else { return nil }
        
        self.init(creator: creator, members: members, questions: questions, code: code, state: state, date: date, title: title)
    }
}


// Votes are given the same length and the same index as questions

struct Votes {
    let data: [Int]
    
    var dictionary: [String: Any] {
        return [
            "data": data
        ]
    }
}

extension Votes: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let data = dictionary["data"] as? [Int]
            else { return nil }
        
        self.init(data: data)
    }
}

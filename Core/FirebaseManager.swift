//
//  FirebaseManager.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    
    private let db = Firestore.firestore()
    
    private lazy var settings: FirestoreSettings = {
        let settings = FirestoreSettings()
        settings.areTimestampsInSnapshotsEnabled = true
        return settings
    }()
    
    init() {
        db.settings = settings
    }
    
    
    // MARK: - Create
    
    func addRoom(uid: String?=nil, room: Room, completion: @escaping (Error?) -> Void) {
        
        let roomRef = db.collection(roomCollection)
        
        if let uid = uid {
            roomRef.document(uid).setData(room.dictionary) { (err) in
                if let err = err {
                    completion(err)
                }
                else {
                    var voteArray = [Int]()
                    room.questions.forEach({ _ in
                        voteArray.append(0)
                    })
                    let votes = Votes(data: voteArray)
                    roomRef.document(uid).collection("votes").document("votes").setData(["data" : votes], completion: { (err) in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    })
                }
            }
        }
        else {
            // Guest Room
            let guestRef = roomRef.document()
            guestRef.setData(room.dictionary) { (err) in
                if let err = err {
                    completion(err)
                }
                else {
                    var voteArray = [Int]()
                    room.questions.forEach({ _ in
                        voteArray.append(0)
                    })
                    guestRef.collection("votes").document("votes").setData(["data" : voteArray], completion: { (err) in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Listen
    
    func addRoomListener(code: String, completion: @escaping (Error?, Room?, Votes?) -> Void) {
        let codeQuery = db.collection(roomCollection).whereField("code", isEqualTo: code)
        
        codeQuery.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                completion(err, nil, nil)
            }
            else {
                if querySnapshot?.documents.count == 1 {
                    let document = querySnapshot?.documents[0]
                    guard let roomData = document?.data(), let documentID = document?.documentID else {
                        let error = NSError(domain: "", code: 0, userInfo: nil)
                        completion(error, nil, nil)
                        return
                    }
                    
                    self.db.collection(self.roomCollection).document(documentID).collection("votes").document("votes").addSnapshotListener({ (documentSnapShot, err) in
                        if let err = err {
                            completion(err, nil, nil)
                        }
                        else {
                            
                            if let votes = documentSnapShot.flatMap({
                                $0.data().flatMap({ data in
                                    return Votes(dictionary: data)
                                })
                            }) {
                                let room = Room(dictionary: roomData)
                                completion(nil, room, votes)
                            }
                            else {
                                let err = NSError(domain: "", code: 0, userInfo: nil)
                                completion(err, nil, nil)
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    // MARK: - Listen
    
    func joinRoom(name: String, code: String, completion: @escaping (Error?) -> Void) {
        let codeQuery = db.collection(roomCollection).whereField("code", isEqualTo: code)
        
        codeQuery.getDocuments { (querySnapshot, err) in
            if let err = err {
                completion(err)
            }
            else {
                if querySnapshot?.documents.count == 1 {
                    let document = querySnapshot?.documents[0]
                    guard let documentID = document?.documentID else {
                        let error = NSError(domain: "", code: 0, userInfo: nil)
                        completion(error)
                        return
                    }
                    
                    self.updateJoinRoomData(documentID: documentID, name: name, completion: { (err) in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    })
                }
            }
        }
    }
    
    
    // MARK: - Update
    
    func updateVote(votes: [Int], code: String, completion: @escaping (Error?) -> Void) {
        let roomRef = db.collection(roomCollection)
        roomRef.whereField(FirebaseConstant.Code, isEqualTo: code).getDocuments { (querySnapshot, err) in
            if let err = err {
                completion(err)
            }
            else {
                
                if querySnapshot?.documents.count == 1 {
                    let document = querySnapshot?.documents[0]
                    guard let documentID = document?.documentID else { return }
                    
                    roomRef.document(documentID)
                        .collection(FirebaseConstant.Votes)
                        .document(FirebaseConstant.Votes)
                        .setData([FirebaseConstant.VoteData : votes], completion: { (err) in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    })
                }
                else {
                    
                }
            }
        }
    }
    
    func removeRoom(code: String, completion: @escaping (Error?) -> Void) {
        db.collection(FirebaseConstant.Rooms).whereField(FirebaseConstant.Code, isEqualTo: code).getDocuments { (querySnapshot, err) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.count == 1 {
                    let document = querySnapshot.documents[0]
                    self.db.collection(FirebaseConstant.Rooms).document(document.documentID).delete(completion: { (err) in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    })
                }
            }
            else {
                completion(err)
            }
        }
    }
    
    
    // MARK: - Private
    
    private func updateJoinRoomData(documentID: String, name: String, completion: @escaping (Error?) -> Void) {
        db.collection(roomCollection).document(documentID).getDocument { (document, err) in
            if let err = err {
                completion(err)
            }
            else {
                if let room = document.flatMap({
                    $0.data().flatMap({ (data) in
                        return Room(dictionary: data)
                    })
                }) {
                    var members = room.members
                    members.append(name)
       
                    self.db.collection(self.roomCollection).document(documentID).updateData(["members" : members], completion: { (err) in
                        if let err = err {
                            completion(err)
                        }
                        else {
                            completion(nil)
                        }
                    })
                }
                else {
                    completion(NSError(domain: "", code: 0, userInfo: nil))
                }
            }
        }
    }
}

extension FirebaseManager {
    
    static let shared = FirebaseManager()
    
    var roomCollection: String {
        return "rooms"
    }
}

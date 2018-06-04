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
        
        let roomRef = db.collection(FirebaseConstant.STORE_ROOMS)
        
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
                    roomRef.document(uid).collection(FirebaseConstant.STORE_VOTES).document(FirebaseConstant.STORE_VOTES).setData([FirebaseConstant.VOTES_KEY_DATA : votes], completion: { (err) in
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
                    guestRef.collection(FirebaseConstant.STORE_VOTES).document(FirebaseConstant.STORE_VOTES).setData([FirebaseConstant.VOTES_KEY_DATA : voteArray], completion: { (err) in
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
        let codeQuery = db.collection(FirebaseConstant.STORE_ROOMS).whereField(FirebaseConstant.ROOMS_KEY_CODE, isEqualTo: code)
        
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
                    
                    self.db.collection(FirebaseConstant.STORE_ROOMS).document(documentID).collection(FirebaseConstant.STORE_VOTES).document(FirebaseConstant.STORE_VOTES).addSnapshotListener({ (documentSnapShot, err) in
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
        let codeQuery = db.collection(FirebaseConstant.STORE_ROOMS).whereField(FirebaseConstant.ROOMS_KEY_CODE, isEqualTo: code)
        
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
        let roomRef = db.collection(FirebaseConstant.STORE_ROOMS)
        roomRef.whereField(FirebaseConstant.ROOMS_KEY_CODE, isEqualTo: code).getDocuments { (querySnapshot, err) in
            if let err = err {
                completion(err)
            }
            else {
                
                if querySnapshot?.documents.count == 1 {
                    let document = querySnapshot?.documents[0]
                    guard let documentID = document?.documentID else { return }
                    
                    roomRef.document(documentID)
                        .collection(FirebaseConstant.STORE_VOTES)
                        .document(FirebaseConstant.STORE_VOTES)
                        .setData([FirebaseConstant.VOTES_KEY_DATA : votes], completion: { (err) in
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
    
    func updateState(state: String, code: String, completion: @escaping (Error?) -> Void) {
        let roomRef = db.collection(FirebaseConstant.STORE_ROOMS)
        roomRef.whereField(FirebaseConstant.ROOMS_KEY_CODE, isEqualTo: code).getDocuments { (querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {
                completion(err!)
                return
            }
            
            guard querySnapshot.documents.count == 1 else { return }
            let document = querySnapshot.documents[0]
            
            roomRef.document(document.documentID).updateData([FirebaseConstant.ROOMS_KEY_STATE : state], completion: { (err) in
                if let err = err {
                    completion(err)
                }
                else {
                    completion(nil)
                }
            })
        }
    }
    
    func removeRoom(code: String, completion: @escaping (Error?) -> Void) {
        db.collection(FirebaseConstant.STORE_ROOMS).whereField(FirebaseConstant.ROOMS_KEY_CODE, isEqualTo: code).getDocuments { (querySnapshot, err) in
            if let querySnapshot = querySnapshot {
                if querySnapshot.documents.count == 1 {
                    let document = querySnapshot.documents[0]
                    self.db.collection(FirebaseConstant.STORE_ROOMS).document(document.documentID).delete(completion: { (err) in
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
        db.collection(FirebaseConstant.STORE_ROOMS).document(documentID).getDocument { (document, err) in
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
       
                    self.db.collection(FirebaseConstant.STORE_ROOMS).document(documentID).updateData([FirebaseConstant.ROOMS_KEY_MEMBERS : members], completion: { (err) in
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
}

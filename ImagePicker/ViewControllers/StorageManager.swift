//
//  StorageManager.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 3.11.22.
//

import Foundation

class StorageManager{
    static var shared = StorageManager()
    private var storage = UserDefaults.standard
    private init(){}
    var isFirstLoad : Bool {
        get{
            !storage.bool(forKey: "firstLoad")
        }
        set{
            storage.set(!newValue, forKey: "firstLoad")
        }
    }
    var pinCode: String {
        get {
            storage.string(forKey: "pinCode") ?? ""
        }
        set {
            storage.set(newValue, forKey: "pinCode")
        }
    }
    var questionAnswer: String {
        get {
            storage.string(forKey: "questionAnswer") ?? ""
        }
        set {
            storage.set(newValue, forKey: "questionAnswer")
        }
    }
}

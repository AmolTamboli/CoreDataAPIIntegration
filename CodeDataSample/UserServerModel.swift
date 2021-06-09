//
//  UserServerModel.swift
//  CodeDataSample
//
//  Created by Amol Tamboli on 08/06/21.
//

import Foundation

struct UserServerModel: Codable {
    let id: Int
    let avatar: String
    let email: String
    let first_name: String
    let last_name: String
    
    static let database = DatabaseHandler.shared
    func storeData(){
        guard let user = UserServerModel.database.add(_type: User.self) else { return }
        user.avatar = avatar
        user.id = Int16(id)
        user.first_name = first_name
        user.last_name = last_name
        user.email = email
        UserServerModel.database.save()
    }
}

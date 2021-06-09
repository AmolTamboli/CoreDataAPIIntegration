//
//  APIHandler.swift
//  CodeDataSample
//
//  Created by Amol Tamboli on 08/06/21.
//

import Foundation

class APIHandler {
    static let shared = APIHandler()
    
    func getData(completion: @escaping(() -> Void)) {
        var request = URLRequest(url: URL(string: "https://reqres.in/api/users/")!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            print(response!)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                let model = try JSONDecoder().decode(APIResponse<[UserServerModel]>.self, from: data!)
                
                model.data.forEach { $0.storeData() }

                completion()
            } catch {
                print(error.localizedDescription)
                completion()
            }
        }
        task.resume()
        
    }
}

public struct APIResponse<T: Codable> : Codable{
    public let page: Int
    public let total: Int
    public let total_pages: Int
    public let per_page: Int
    public let data: T
}

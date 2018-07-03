//
//  APIManager.swift
//  NotesCoreData_RestApi
//
//  Created by Oleg Granchenko on 7/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    func getAllNotes(complition: @escaping (Data) -> ()) {
        let url = URL(string: Constant.baseURL + "notes")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
                complition(data)
            }
        }
        
        task.resume()
    }
    
    func createNote(title: String, info: String, complition: @escaping (Data) -> ()) {
        let url = URL(string: Constant.baseURL + "notes")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\n  \"title\": \"\(title), \"info\": \"\(info)\n}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
                complition(data)
            }
        }
        
        task.resume()
    }
    
    func getNote(with id: String, complition: @escaping (Data) -> ()) {
        let url = URL(string: Constant.baseURL + "/notes/\(id)")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
                complition(data)
            }
        }
        
        task.resume()
    }
    
    func updateNote(with id: String, complition: @escaping (Data) -> ()) {
        let url = URL(string: Constant.baseURL + "/notes/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
               complition(data)
            }
        }
        task.resume()
    }
    
    func deleteNote(with id: String, completion: @escaping ()->()) {
        
        let url = URL(string: Constant.baseURL + "/notes/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                completion()
            } 
        }
        
        task.resume()
    }
}

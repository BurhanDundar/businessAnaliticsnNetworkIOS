//
//  APIRequest.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 26.05.2023.
//

// URLSession vs Alamofire
// Alamofire paket yükümlülükleriyle geliyor dolayısıyla ilk tercih olmamalı

// Bunlar burda bir şablon olarak dursun

import Foundation

struct APIRequest {
    
    func getData(from stringURL: String){
        
        guard let url = URL(string: stringURL) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("there was an error: \(error.localizedDescription)")
            } else {
                let jsonRes = try? JSONSerialization.jsonObject(with: data!, options: [])
                print("the response is: \(jsonRes!)")
            }
        }
        session.resume()
    }
    
    func postData(from stringURL: String, params: Dictionary<String,Any>){  // NSObject mi emin değilim burası
        
        guard let url = URL(string: stringURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("there was an error: \(error.localizedDescription)")
            } else {
                let jsonRes = try? JSONSerialization.jsonObject(with: data!, options: [])
                print("the response is: \(jsonRes!)")
            }
        }
        
        session.resume()
    }
    
}

/*
 func getData(){
 
    let stringURL = "http://192.168.2.62:3001/user"
     
     guard let url = URL(string: stringURL) else { return }
     let session = URLSession.shared.dataTask(with: url) { data, response, error in
         if let error = error {
             print("there was an error: \(error.localizedDescription)")
         }
         
         guard let data = data else { return }
         
         do {
             let decoder = JSONDecoder()
             let response = try decoder.decode([User].self, from: data)
             //print(response[0].title ?? "")
         } catch {
             print("Error Occured!")
         }
         
     }
     session.resume()
 }
 
 func postData(from stringURL: String, params: Dictionary<String,Any>){  // NSObject mi emin değilim burası
     
     guard let url = URL(string: stringURL) else { return }
     
     var request = URLRequest(url: url)
     request.httpMethod = "POST"
     request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
     
     
     
     let session = URLSession.shared.dataTask(with: request) { data, response, error in
     
         guard let data = data else { return }
         
         if let error = error {
             print("there was an error: \(error.localizedDescription)")
         } else {
             let decoder = JSONDecoder()
             let jsonRes = try? decoder.decode([User].self, from: data) //try? JSONSerialization.jsonObject(with: data!, options: [])
             print("the response is: \(jsonRes!)")
         }
     }
     
     session.resume()
 }

 let params = [
     "full_name": "Murat Osman ÜNALIR"
 ]

 postData(from: "http://localhost:3001/user/filter",params: params)
 
 */

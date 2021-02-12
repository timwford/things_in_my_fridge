//
//  FoodModel.swift
//  Things In My Fridge
//
//  Created by Tim Ford on 2/10/21.
//

import Foundation

class FoodModel : ObservableObject {
    
    static let urlStr = "http://209.159.204.189:4000/food/"
    
    let url = URL(string: FoodModel.urlStr)!
    let all_url = URL(string: "\(FoodModel.urlStr)?active=true")!
    let session = URLSession.shared
    
    static var shared = FoodModel()
    
    @Published var in_the_fridge: [Food] = []
    
    init() {
        load()
    }
    
    func load() {
        let task = session.dataTask(with: all_url, completionHandler: { data, response, error in
            // Check the response
            print(response)
            
            // Check if an error occured
            if error != nil {
                // HERE you can manage the error
                print(error)
                return
            }
            
            // Serialize the data into an object
            do {
                DispatchQueue.main.async {
                    self.in_the_fridge = try! JSONDecoder().decode([Food].self, from: data!)
                    self.objectWillChange.send()
                }
                
            } catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
            
        })
        
        task.resume()
    }
    
    func update(schema: Food) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder.init().encode(schema)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            self.load()
        }

        task.resume()
    }
    
    /*
    func delete(id: String) {
        let deleteUrl = URL(string: FoodModel.urlStr + "/" + String(id))!
        
        var request = URLRequest(url: deleteUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            self.load()
        }

        task.resume()
    }
    */
}

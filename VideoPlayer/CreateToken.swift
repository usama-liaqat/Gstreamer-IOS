//
//  CreateToken.swift
//  VideoPlayer
//
//  Created by Usama Liaqat on 01/05/2023.
//

import Foundation

struct TokenRequest: Codable {
    let uuid: String
}

struct TokenResponse: Codable {
    let success: Bool
    let message: String
    let data: TokenResponseData
}

struct TokenResponseData: Codable {
    let url: URL
}

func createToken(uuid: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
    let url = URL(string: "https://dev.service.arcadia.theremmie.com/api/create-token")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestData = TokenRequest(uuid: uuid)
    request.httpBody = try? JSONEncoder().encode(requestData)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
            completion(.failure(error))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(TokenResponse.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}

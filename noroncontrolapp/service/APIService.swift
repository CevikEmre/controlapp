import Foundation

class APIService {
    
    static let shared = APIService()
    private let baseURL = "http://noronteknoloji.com/mobile/"
    
    func makeRequest(
        endpoint: String,
        method: String = "POST",
        body: [String: String]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            let postString = body.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            request.httpBody = postString.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            print("Sending form data: \(postString)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response"])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

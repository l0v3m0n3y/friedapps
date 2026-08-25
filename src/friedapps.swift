import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class Friedapps{
    private let api = "https://api.friedapps.com"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"
        ]

    }
    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getDomainsList() async throws -> Any {
        return try await fetchJSON(from: "\(api)/temp-mail/domains")
    }

    public func generateEmail() async throws -> Any {
        let urlString = "\(api)/temp-mail/addresses"
        
        let bodyData = try? JSONSerialization.data(withJSONObject: [:], options: [])
        
        return try await fetchJSON(from: urlString,method: .post,body: bodyData,queryParameters: nil)
    }

    public func deleteEmailAddress(emailId: String) async throws -> Any {
        let urlString = "\(api)/temp-mail/addresses/\(emailId)"
        
        let bodyData = try? JSONSerialization.data(withJSONObject: [:], options: [])
        
        return try await fetchJSON(from: urlString,method: .delete,body: bodyData,queryParameters: nil)
    }

    public func getEmailsList(limit: Int = 50) async throws -> Any {
        return try await fetchJSON(from: "\(api)/temp-mail/emails?limit=\(limit)")
    }

    public func getMessage(emailId: String) async throws -> Any {
        return try await fetchJSON(from: "\(api)/temp-mail/emails/\(emailId)")
    }
}

import Foundation

public typealias JSON = [String: Any]

public struct CoreAPI {
    private static let session = URLSession(configuration: .default)
    private static let baseURL = URL(string: "https://api.reddit.com")!

    public static func getData(forRoute route: APIRoute, parameters: [String: String],
                               completion: @escaping (Result<JSON>) -> Void) -> URLSessionTask {
        let url = route.resolving(baseURL: self.baseURL, parameters: parameters)
        let task = self.session.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            if let json = self.json(from: data) {
                return completion(Result(success: json))
            }

            completion(Result(error: CoreAPIError.random))
        }

        task.resume()
        return task
    }

    public static func json(from data: Data) -> JSON? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON
    }
}

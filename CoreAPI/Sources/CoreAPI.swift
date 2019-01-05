import Foundation

public struct CoreAPI {
    private static let session = URLSession(configuration: .default)
    private static let baseURL = URL(string: "https://api.reddit.com")!

    public static func getData(forRoute route: APIRoute, parameters: [String: String],
                               completion: @escaping (Result<Data>) -> Void) -> URLSessionTask {
        let url = route.resolving(baseURL: self.baseURL, parameters: parameters)
        let task = self.session.dataTask(with: url) { (data, _, _) in
            if let data = data {
                completion(Result(success: data))
            } else {
                completion(Result(error: CoreAPIError.random))
            }
        }

        task.resume()
        return task
    }
}

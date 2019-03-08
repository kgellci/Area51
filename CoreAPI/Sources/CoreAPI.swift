import Foundation

public struct CoreAPI {
    private static let baseURL = URL(string: "https://api.reddit.com")!

    public static func getData(forRoute route: APIRoute,
                               parameters: [String: String],
                               session: NetworkSession = URLSession.shared,
                               completion: @escaping (Result<Data>) -> Void) -> URLSessionTask {
        let url = route.resolving(baseURL: self.baseURL, parameters: parameters)
        let task = session.dataTask(with: url) { (data, _, _) in
            if let data = data {
                completion(Result(success: data))
            } else {
                completion(Result(error: CoreAPIError.random))
            }
        }

        task.resume()
        return task
    }
    public static func getSearchData(forRoute route: APIRoute,
                                     parameters: [String: String],
                                     query: String,
                                     session: NetworkSession = URLSession.shared,
                                     completion: @escaping (Result<Data>) -> Void) -> URLSessionTask {
        let url = route.resolvingSearch(baseURL: self.baseURL, parameters: parameters, query: query)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, _, _) in
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

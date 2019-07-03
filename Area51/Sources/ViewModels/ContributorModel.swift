import Foundation
import UIKit

struct Contributor: Decodable {
    var login: String?
    var name: String?
    var contributions: Int

    static func getContributors(completion: @escaping (Result<[Contributor], Error>) -> Void) {
        let request = "https://api.github.com/repos/kgellci/Area51/contributors?anon=1"
        guard let url = URL(string: request) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let data = data else { return }

            do {
                let contributors = try JSONDecoder().decode([Contributor].self, from: data)
                completion(.success(contributors))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
            }.resume()
    }

}

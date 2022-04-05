
import Foundation
struct ParseJSON {
    func parseNetworkJSON<T: Codable>(urlApi: String, type: T.Type, complited: @escaping (T?) -> Void) {
        guard let url = URL(string: urlApi) else { return }
        let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: url) { data, response, error in
                        if let httpResponse = response as? HTTPURLResponse,
                           (200...299).contains(httpResponse.statusCode) {
                            if let data = data {
                                do {
                                    let decodeJSON = try JSONDecoder().decode(type.self, from: data)
                                    complited(decodeJSON)
                                } catch {
                                    print(error)
                                }
                            }
                        } else {
                            complited(nil)
                            }
                    }
                    task.resume()
    }
}
   

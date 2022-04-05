
import Foundation

struct ChannelsStruct: Codable {
    let channels: [Channel]
    
}

struct Channel: Codable {
    let nameRu: String
    let image: String?
    let url: String
    let current: Current?
    
    enum CodingKeys: String, CodingKey {
        case nameRu = "name_ru"
        case image, current, url
    }
}
struct Current: Codable {
    let title: String
}


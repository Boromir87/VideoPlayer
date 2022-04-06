
import Foundation
import RealmSwift

class ChannelBody: Object {
    @objc dynamic var name = ""
    @objc dynamic var program = ""
    @objc dynamic var image: Data?
    @objc dynamic var isFavourites = false
    @objc dynamic var urlChannel = ""
}

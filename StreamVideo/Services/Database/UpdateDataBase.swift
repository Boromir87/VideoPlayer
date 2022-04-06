
import Foundation
import RealmSwift

class UpdateDataBase {
    func updateFavouritesChannel(channelName: String) {
        let predicate = NSPredicate(format: "name == [c]%@", channelName)
        do {
            try Realm().write({
                let channel = try Realm().objects(ChannelBody.self).filter(predicate)                
                channel[0].isFavourites = !channel[0].isFavourites
            })
        } catch {
            print("Error")
        }
    }
}

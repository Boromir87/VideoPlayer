
import Foundation
import RealmSwift

class FillDataBase {
    
    weak var delegate: UpdateViewProtocol?
    
    func loadChannels() {
        let api = "http://limehd.online/playlist"
        ParseJSON().parseNetworkJSON(urlApi: api, type: ChannelsStruct.self, complited: { elements in
            LoadFromDatabase().fillRealmListChannel(urlApi: api, channels: elements?.channels ?? [])
            let listChannels = getChannels(channels: elements)
            if listChannels.count != 0 {
                self.delegate?.updateChannels(channels: listChannels)
            }
        })
    }
}

func getChannels(channels: ChannelsStruct?) -> [ChannelBody] {    
    var list: [ChannelBody] = []
    channels?.channels.forEach({
                            let elem = ChannelBody()
                            elem.name = $0.nameRu
                            elem.program = $0.current?.title ?? "NET"
                            elem.urlChannel = $0.url
                            if let urlImage = URL(string: $0.image ?? ""), let data = try? Data(contentsOf: urlImage) {
                                elem.image = data
                            }
                            list.append(elem)
                        })
    return list
}

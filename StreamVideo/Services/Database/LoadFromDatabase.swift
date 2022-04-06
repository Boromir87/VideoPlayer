
import Foundation
import RealmSwift

class LoadFromDatabase {
    
    let realm = try! Realm()
    lazy var list: Results<ChannelBody> = { realm.objects(ChannelBody.self)}()
    
    func loadFromRealm(predicate: String, isFourites: Bool) -> [ChannelBody] {
        var listChannel: [ChannelBody] = []
        var filtredList = list
        
        if isFourites {
            if predicate == "" {
                let predicatString = NSPredicate(format: "isFavourites == %@", NSNumber(booleanLiteral: true))
                filtredList = list.filter(predicatString)
            } else {
                let predicatString = NSPredicate(format: "isFavourites == %@", NSNumber(booleanLiteral: true))
                filtredList = list.filter(predicatString)
                let predicatName = NSPredicate(format: "name CONTAINS[c]%@", predicate)
                filtredList = filtredList.filter(predicatName)
            }
        } else {
            if predicate == "" {
                filtredList = list
            } else {
                let predicatName = NSPredicate(format: "name CONTAINS[c]%@", predicate)
                filtredList = list.filter(predicatName)
            }
        }

        if filtredList.count != 0 {
            
            for elem in filtredList {
                listChannel.append(elem)
            }
        }
        return listChannel
    }
    
    func fillRealmListChannel(urlApi: String, channels: [Channel]) {
        
        if list.count == 0 {
            do {
                try realm.write({
                    
                    for elem in channels {
                        let newChannel = ChannelBody()
                        newChannel.name = elem.nameRu
                        newChannel.program = elem.current?.title ?? "Net"
                        newChannel.isFavourites = false
                        newChannel.urlChannel = elem.url
                        if let str = elem.image, let url = URL(string: str) {
                            let data = try Data(contentsOf: url)
                            newChannel.image = data
                        }
                        realm.add(newChannel)
                    }
                })
            } catch {
                print("REALM ERROR")
            }
        }
    }
    
}

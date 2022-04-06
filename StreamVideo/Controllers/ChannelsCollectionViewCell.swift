
import UIKit

class ChannelsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var programName: UILabel!
    @IBOutlet weak var favouritesImageActive: UIButton!
    @IBOutlet weak var favouritesImage: UIButton!
    
    weak var delegate: UpdateViewProtocol?
    
    func configureCell(_channelImage: UIImage, _channelName: String, _programName: String, _favouritesImage: Bool) {
        channelImage.image = _channelImage
        channelName.text = _channelName
        programName.text = _programName
        if _favouritesImage {
            favouritesImage.isHidden = false
            favouritesImageActive.isHidden = true
        } else {
            favouritesImage.isHidden = true
            favouritesImageActive.isHidden = false
        }
    }

    @IBAction func tapStar(_ sender: UIButton) {
        favouritesImage.isHidden = true
        favouritesImageActive.isHidden = false
        UpdateDataBase().updateFavouritesChannel(channelName: channelName.text ?? "")
    }
    @IBAction func tapActiveStar(_ sender: UIButton) {
        favouritesImage.isHidden = false
        favouritesImageActive.isHidden = true
        UpdateDataBase().updateFavouritesChannel(channelName: channelName.text ?? "")
        if let isFavourite = delegate?.isFavouritesChannels, isFavourite, let searchStr = delegate?.searchText {
            let channels = LoadFromDatabase().loadFromRealm(predicate: searchStr, isFourites: true)
            delegate?.updateChannels(channels: channels)
        }
    }
}

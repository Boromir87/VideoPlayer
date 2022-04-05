
import UIKit
import AVKit

class VideoViewController: UIViewController {

    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelProgramText: UILabel!
    @IBOutlet weak var channelNameText: UILabel!
    @IBOutlet weak var qualityVideoBtn: UIButton!
    @IBOutlet weak var qualityTable: UITableView!
    
    var channelName: String?
    var channelProgram: String?
    var channelUrl: String?
    var channelIcon: Data?
    
    let qualityTypeChannel = ["1080p","720p","480p","360p","AUTO"]
    let qualityVideo = ["tracks-v4a1/mono.m3u8",
                        "tracks-v3a1/mono.m3u8",
                        "tracks-v2a1/mono.m3u8",
                        "tracks-v1a1/mono.m3u8",
                        "index.m3u8"]
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        qualityTable.rowHeight = qualityTable.frame.height / 5
        qualityTable.layer.cornerRadius = 12
        
        channelNameText.text = channelName
        channelProgramText.text = channelProgram
        if let data = channelIcon {
            channelImage.image = UIImage(data: data)
        }
    }
    
    
    @IBAction func tapStart(_ sender: Any) {
        player = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let channelUrl = channelUrl, let newUrl = URL(string: channelUrl) else {return}

        player = AVPlayer()
        guard let player = player else { return }
        let playerItem = AVPlayerItem(url: newUrl)
        player.replaceCurrentItem(with: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resize
        videoView.layer.addSublayer(playerLayer)
        player.play()
        
        let indexPath = IndexPath(row: 4, section: 0)
        qualityTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        let selectedCell = qualityTable.cellForRow(at: indexPath) as? QualityVideoTableCell
        selectedCell?.contentView.backgroundColor = UIColor(red: 0, green: 0.467, blue: 1, alpha: 1)
        selectedCell?.qualityText.textColor = .white
    }
    
    @IBAction func tapQualityButton(_ sender: Any) {
        qualityTable.isHidden = !qualityTable.isHidden
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }    
    override var shouldAutorotate: Bool {
        return true
    }
}

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qualityTypeChannel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "qualityCell") as? QualityVideoTableCell else {
            return UITableViewCell()
        }
        cell.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        cell.qualityText.textColor = .black
        cell.qualityText.text = qualityTypeChannel[indexPath.row]
        return cell
    }
}

extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channelUrl = channelUrl else { return }
        if let index = channelUrl.index(of: "index.m3u8") {
            var substr = channelUrl[..<index]
            substr += qualityVideo[indexPath.row]
            guard let url = URL(string: String(substr)) else { return }
            let playerItem = AVPlayerItem(url: url)
            player?.replaceCurrentItem(with: playerItem)
        }
        let selectedCell = tableView.cellForRow(at: indexPath) as? QualityVideoTableCell
        selectedCell?.contentView.backgroundColor = UIColor(red: 0, green: 0.467, blue: 1, alpha: 1)
        selectedCell?.qualityText.textColor = .white
        qualityTable.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedCell = tableView.cellForRow(at: indexPath) as? QualityVideoTableCell
        deselectedCell?.contentView.backgroundColor = .white
        deselectedCell?.qualityText.textColor = .black
    }    
}

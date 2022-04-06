
import UIKit

protocol UpdateViewProtocol: AnyObject {
    func updateChannels(channels: [ChannelBody])
    var isFavouritesChannels: Bool? { get }
    var searchText: String? { get }
}

class ListViewController: UIViewController, UpdateViewProtocol {
    var searchText: String?
    var isFavouritesChannels: Bool?
    var listChannels: [ChannelBody] = []

    @IBOutlet weak var searchChanels: UITextField!
    @IBOutlet weak var allChanels: UILabel!
    @IBOutlet weak var allChanelsView: UIView!
    @IBOutlet weak var allChanelsSelection: UIView!
    @IBOutlet weak var allChanelBtn: UIButton!
    @IBOutlet weak var favouritesChanels: UILabel!
    @IBOutlet weak var favouritesChanelsView: UIView!
    @IBOutlet weak var favouritesChanelsSelection: UIView!
    @IBOutlet weak var collectionListChannel: UICollectionView!
    
    @objc dynamic var searchString: String?
    var searchStringObservation: NSKeyValueObservation?
    
    let activityView = UIActivityIndicatorView()
    let fadeView:UIView = UIView()
    
    func configureSearchBar() {
        searchChanels.layer.cornerRadius = 16
        searchChanels.attributedPlaceholder = NSAttributedString(
            string: "Напишите название телеканала", attributes: [NSAttributedString.Key.foregroundColor : UIColor.searchTextColor])
        searchChanels.font = .sfProTextRegular
        searchChanels.backgroundColor = .backgroundTextfield
        let searchImage = UIImageView(frame: CGRect(x: 15, y: 15, width: 18, height: 18))
                searchImage.image = .searchIcon
        searchChanels.addSubview(searchImage)
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 0))
        searchChanels.leftView = paddingLeft
        searchChanels.leftViewMode = .always
        searchChanels.clipsToBounds = true
    }
    
    func configureActivityIndicator() {
        activityView.style = .large
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = .white
        fadeView.alpha = 0.4
        self.view.addSubview(fadeView)
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portraitUpsideDown, .portrait]
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        searchChanels.delegate = self
        
        listChannels = LoadFromDatabase().loadFromRealm(predicate: "", isFourites: false)
        favouritesChanelsSelection.isHidden = true
        allChanelBtn.tintColor = UIColor.clear
        
        isFavouritesChannels = false
        
        let fill = FillDataBase()
        fill.delegate = self
        
        if listChannels.count == 0 {
           configureActivityIndicator()
            fill.loadChannels()
        }
        
        searchStringObservation = observe(\ListViewController.searchString, options: .new, changeHandler: {[weak self] (vc, value) in
            guard let inputText = value.newValue as? String else {return}
            self?.searchText = inputText
            self?.listChannels = LoadFromDatabase().loadFromRealm(
                predicate: inputText, isFourites: self?.allChanelsSelection.isHidden ?? true)            
            DispatchQueue.main.async {
                self?.collectionListChannel.reloadData()
            }
        })
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for txt in self.view.subviews {
            if txt.isKind(of: UITextField.self) && txt.isFirstResponder {
                txt.resignFirstResponder()
            }
        }
    }
    
    func updateChannels(channels: [ChannelBody]) {
        self.listChannels = channels        
        DispatchQueue.main.async {
            self.fadeView.removeFromSuperview()
            self.activityView.stopAnimating()
            self.collectionListChannel.reloadData()
        }
    }
    
    
//MARK: - ACTIONS
    
    @IBAction func favouritesChanelsTapped(_ sender: Any) {
        if favouritesChanelsSelection.isHidden == true {
            searchChanels.text = ""
            listChannels = LoadFromDatabase().loadFromRealm(predicate: "", isFourites: true)
            collectionListChannel.reloadData()
        }
        isFavouritesChannels = true
        searchText = ""
        
        favouritesChanelsSelection.isHidden = false
        allChanelsSelection.isHidden = true
        allChanels.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        favouritesChanels.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @IBAction func allChanelsTapped(_ sender: Any) {
        if allChanelsSelection.isHidden == true {
            searchChanels.text = ""
            listChannels = LoadFromDatabase().loadFromRealm(predicate: "", isFourites: false)
            collectionListChannel.reloadData()
        }
        isFavouritesChannels = false
        searchText = ""
        
        favouritesChanelsSelection.isHidden = true
        allChanelsSelection.isHidden = false
        allChanels.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        favouritesChanels.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    @IBAction func searchEdited(_ sender: Any) {
        searchString = searchChanels.text
    }
    
}

//MARK: - EXTENSSION

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listChannels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "chanelCell", for: indexPath) as? ChannelsCollectionViewCell else { return UICollectionViewCell() }
        cell.delegate = self
        
        cell.layer.cornerRadius = 10
        cell.channelName.text = listChannels[indexPath.row].name
        cell.programName.text = listChannels[indexPath.row].program
        if listChannels[indexPath.row].isFavourites {
            cell.favouritesImage.isHidden = true
            cell.favouritesImageActive.isHidden = false
        } else {
            cell.favouritesImage.isHidden = false
            cell.favouritesImageActive.isHidden = true
        }
        if let data = listChannels[indexPath.row].image {
            cell.channelImage.image = UIImage(data: data)
        }
        return cell
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = width / 4.5
        return CGSize(width: width, height: height)
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let videoVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? VideoViewController else { return }
        
        videoVC.channelName = listChannels[indexPath.row].name
        videoVC.channelProgram = listChannels[indexPath.row].program
        videoVC.channelUrl = listChannels[indexPath.row].urlChannel
        videoVC.channelIcon = listChannels[indexPath.row].image
        
        present(videoVC, animated: true, completion: nil)        
    }
}

extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

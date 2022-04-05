
import UIKit

extension UIColor {
    public static var backgroundListChanels: UIColor  {
        return UIColor(named: "background_chanelList") ?? UIColor.yellow    }
    public static var searchTextColor: UIColor  {
        return UIColor(named: "textfield_Text") ?? UIColor.yellow    }
    public static var backgroundTextfield: UIColor  {
        return UIColor(named: "textfield") ?? UIColor.yellow    }
}

extension CGColor {
    public static var backgroundColor: CGColor {
        (UIColor(named: "backgroundColor") ?? UIColor.yellow).cgColor    }
    public static var chanelCellColor: CGColor {
        (UIColor(named: "cell_backgroundColor") ?? UIColor.yellow).cgColor    }
    public static var searchTextColor: CGColor  {
        return UIColor(named: "textfield_Text")?.cgColor ?? UIColor.yellow.cgColor    }
}

extension UIImage {
    public static var searchIcon: UIImage {
        UIImage(named: "search_icon") ?? UIImage()    }
    public static var starActive: UIImage {
        UIImage(named: "star_active") ?? UIImage()    }
    public static var starDefault: UIImage {
        UIImage(named: "star_default") ?? UIImage()    }
    public static var videoQuality: UIImage {
        UIImage(named: "video_quality_icon") ?? UIImage()    }
}

extension UIFont {
    public static var sfProTextRegular: UIFont {
        UIFont(name: "SFProText-Regular", size: 17)  ?? UIFont.systemFont(ofSize: 17) }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }    
}

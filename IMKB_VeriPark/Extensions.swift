
import UIKit
import Foundation
import CryptoSwift
import SystemConfiguration

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView {
    public var width : CGFloat {
        return self.frame.size.width
    }
    public var height : CGFloat {
        return self.frame.size.height
    }
    public var top : CGFloat {
        return self.frame.origin.y
    }
    public var bottom : CGFloat {
        return self.frame.height + self.frame.origin.y
    }
    public var left : CGFloat {
        return self.frame.origin.x
    }
    public var right : CGFloat {
        return self.frame.width + self.frame.origin.x
    }
}

extension UILabel {
    func addImageWith(name: String, behindText: Bool) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        let attachmentString = NSAttributedString(attachment: attachment)
        
        guard let txt = self.text else {
            return
        }
        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
private var aesKey: String? {
    return UserDefaults.standard.string(forKey: "aesKey")
}
private var aesIV: String? {
    return UserDefaults.standard.string(forKey: "aesIV")
}

extension String {

    func aesDecrypt() -> String {
        guard let aesKey = aesKey, let aesIV = aesIV else { return ""}
        let key = [UInt8](base64: aesKey)
        let iv = [UInt8](base64: aesIV)
        let aes = try? AES(key: key, blockMode: CBC(iv: iv))
        
        let cipherdata = Data(base64Encoded: self)
        let ciphertext = try? aes?.decrypt(cipherdata!.bytes)
        guard let token = String(bytes:ciphertext!, encoding:String.Encoding.utf8) else {return ""}
        
        return token
    }

    func aesEncryption() -> String? {
        let key = [UInt8](base64: aesKey ?? "")
        let iv = [UInt8](base64: aesIV ?? "")
        let aes = try? AES(key: key, blockMode: CBC(iv: iv))
        
        let cipherText = try? aes?.encrypt(Array(self.utf8))
        let base64String = cipherText?.toBase64()
        return base64String
    }
}

public extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE 2nd Gen"
            case "iPhone13,1":                              return "iPhone 12 Mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPhone14,2":                              return "iPhone 13 Pro"
            case "iPhone14,3":                              return "iPhone 13 Pro Max"
            case "iPhone14,4":                              return "iPhone 13 Mini"
            case "iPhone14,5":                              return "iPhone 13"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case   "iPad8,9 " :                           return  "iPad Pro 11 inch 4th Gen (WiFi)"
            case   "iPad8,10" :                           return  "iPad Pro 11 inch 4th Gen (WiFi+Cellular)"
            case   "iPad8,11" :                           return  "iPad Pro 12.9 inch 4th Gen (WiFi)"
            case   "iPad8,12" :                           return  "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)"
            case   "iPad11,1" :                           return  "iPad mini 5th Gen (WiFi)"
            case   "iPad11,2" :                           return  "iPad mini 5th Gen"
            case   "iPad11,3" :                           return  "iPad Air 3rd Gen (WiFi)"
            case   "iPad11,4" :                           return  "iPad Air 3rd Gen"
            case   "iPad11,6" :                           return  "iPad 8th Gen (WiFi)"
            case   "iPad11,7" :                           return  "iPad 8th Gen (WiFi+Cellular)"
            case   "iPad13,1" :                           return  "iPad air 4th Gen (WiFi)"
            case   "iPad13,2" :                           return  "iPad air 4th Gen (WiFi+Cellular)"
            case   "iPad13,4" :                           return  "iPad Pro 11 inch 3rd Gen"
            case   "iPad13,5" :                           return  "iPad Pro 11 inch 3rd Gen"
            case   "iPad13,6" :                           return  "iPad Pro 11 inch 3rd Gen"
            case   "iPad13,7" :                           return  "iPad Pro 11 inch 3rd Gen"
            case   "iPad13,8" :                           return  "iPad Pro 12.9 inch 5th Gen"
            case   "iPad13,9" :                           return  "iPad Pro 12.9 inch 5th Gen"
            case   "iPad13,10":                           return  "iPad Pro 12.9 inch 5th Gen"
            case   "iPad13,11":                           return  "iPad Pro 12.9 inch 5th Gen"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()
}

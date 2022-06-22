//
//  String+ZeroExtension.swift
//  ZeroKit
//
//  Created by zhangzhao on 2022/6/22.
//

import UIKit
import CommonCrypto

// MARK: - 作为错误
public extension String {
    
    private struct ConvenientError: LocalizedError {
        
        let description: String
        
        init(_ str: String) {
            description = str
        }
        
        var errorDescription: String? {
            return description
        }
    }
    
    var asError: LocalizedError {
        return ConvenientError(self)
    }
}

// MARK: - 数字签名/加密
public extension String {
    
    var MD5: String {
        let cStr = cString(using: .utf8)!
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr, (CC_LONG)(strlen(cStr)), buffer)
        var md5Result = ""
        for i in 0 ..< 16 {
            md5Result = md5Result.appendingFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5Result
    }
    
    func HmacSHA1(_ key: String) -> String {
        let cKey = key.cString(using: .ascii)!
        var charactsets: CharacterSet = .urlUserAllowed
        charactsets.remove(charactersIn: ":/,()")
        let encodeStr = addingPercentEncoding(withAllowedCharacters: charactsets) ?? ""
        let cStr = encodeStr.cString(using: .ascii) ?? [CChar(0)]
        var cHmac = Array<CUnsignedChar>(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey, strlen(cKey), cStr, strlen(cStr), &cHmac)
        var HmacResult = ""
        for val in cHmac {
            HmacResult = HmacResult.appendingFormat("%02hhx", val)
        }
        return HmacResult
    }

    func AES128Encryption(iv: String, key: String) -> Data? {
        guard
            iv.count == 16,
            key.count == 16,
            let ivData = iv.data(using: .utf8) as NSData?,
            let keyData = key.data(using: .utf8) as NSData?,
            let data = self.data(using: .utf8) as NSData?
            else
        {
            return nil
        }
        let dataLengthRemainder = data.length % kCCBlockSizeAES128
        let cryptLength = data.length + kCCBlockSizeAES128 - dataLengthRemainder
        let cryptData = NSMutableData.init(length: cryptLength)!
        
        let operation = CCOperation(kCCEncrypt)
        let algorithm = CCAlgorithm(kCCAlgorithmAES128)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted: size_t = 0
        
        let encryptStatus =
            CCCrypt(
                operation,
                algorithm,
                options,
                keyData.bytes,
                keyData.length,
                ivData.bytes,
                data.bytes,
                data.length,
                cryptData.mutableBytes,
                cryptData.length,
                &numBytesEncrypted)
        
        if encryptStatus == kCCSuccess {
            return cryptData as Data?
        }
        
        return nil
    }
}

// MARK: - IP地址判断
public extension String {
    
    func isIPAddress() -> Bool {
        guard count > 0 else { return false }
        let ipv4Regex = "^(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)(\\.(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)){3}$"
        let isIPv4 = NSPredicate(format: "SELF MATCHES %@", ipv4Regex).evaluate(with: self)
        if isIPv4 {
            return true
        }
        // maybe it is ipv6.
        let componentCount = components(separatedBy: ":").count
        if componentCount == 0 || componentCount > 8 {
            return false
        }
        var ipv6Regex = "(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$"
        var isIPv6 = NSPredicate(format: "SELF MATCHES %@", ipv6Regex).evaluate(with: self)
        if isIPv6 {
            return true
        }
        if componentCount == 8 {
            ipv6Regex = "^(::(?:[0-9A-Fa-f]{1,4})(?::[0-9A-Fa-f]{1,4}){5})|((?:[0-9A-Fa-f]{1,4})(?::[0-9A-Fa-f]{1,4}){5}::)$"
        } else {
            ipv6Regex = "^((?:[0-9A-Fa-f]{1,4}(:[0-9A-Fa-f]{1,4})*)?)::((?:([0-9A-Fa-f]{1,4}:)*[0-9A-Fa-f]{1,4})?)$"
        }
        isIPv6 = NSPredicate(format: "SELF MATCHES %@", ipv6Regex).evaluate(with: self)
        return isIPv6
    }
}

// MARK: - 拼音
public extension String {
    
    var toPinYin: String {
        let py = NSMutableString(string: self) as CFMutableString
        CFStringTransform(py, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(py, nil, kCFStringTransformStripDiacritics, false)
        return py as String
    }
}

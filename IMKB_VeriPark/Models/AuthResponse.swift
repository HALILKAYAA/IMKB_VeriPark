
import Foundation

struct AuthResponse: Codable {
    let aesKey: String
    let aesIV: String
    let authorization: String
    let lifeTime: String
    let status: Status
}

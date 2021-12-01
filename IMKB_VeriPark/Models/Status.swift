
import Foundation

struct Status: Codable {
    let isSuccess: Bool
    let error: ErrorResponse
}

struct ErrorResponse: Codable {
    let code: Int
    let message: String?
}

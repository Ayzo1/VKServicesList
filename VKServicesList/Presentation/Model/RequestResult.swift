import Foundation

struct RequestResult: Codable {
	let body: Body
	let status: Int
}

struct Body: Codable {
	let services: [VKService]
}

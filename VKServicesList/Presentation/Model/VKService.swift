import Foundation

struct VKService: Codable {
	
	let name: String
	let description: String
	let link: String
	let iconURL: String
	
	enum CodingKeys: String, CodingKey {
		case name
		case description
		case link
		case iconURL = "icon_url"
	}
}

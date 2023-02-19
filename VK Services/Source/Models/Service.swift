import UIKit

struct Service : Codable{
	var name: String
	var description: String
	var serviceUrl: String
	var iconUrl: String

	var imageData: Data?
	
	private enum CodingKeys: String, CodingKey {
		case name, description, serviceUrl = "service_url", iconUrl = "icon_url"
	}
}

struct ServicesItems: Codable{
	var items: [Service]
}

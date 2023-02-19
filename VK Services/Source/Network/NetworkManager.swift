import Foundation
import UIKit

enum NetworkError: Error {
	case failedToDecodeData
}

final class NetworkManager {

	private var getNewsTask: URLSessionDataTask?

	private var isLoading = false

	func images(forURLs urls: [String?], completion: @escaping ([Data?]) -> Void) {

		guard isLoading == false else { return }

		isLoading = true

		let group = DispatchGroup()
		var imagesData: [Data?] = .init(repeating: nil, count: urls.count)

		for (index, urlString) in urls.enumerated() {
			group.enter()
			DispatchQueue.global().async {
				if let url = URL(string: urlString ?? "") {
					if let data = try? Data(contentsOf: url) {
						imagesData[index] = data
					}
				}
				group.leave()
			}
		}

		group.notify(queue: .main) {
			completion(imagesData)
		}

		isLoading = false
	}
}


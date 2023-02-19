import UIKit

final class ServiceCellViewModel {

	var name: String {
		service.name
	}

	var image: UIImage? {
		if let imageData = service.imageData, let image = UIImage(data: imageData, scale: 0.05) {
			return image
		}
		return nil
	}

	var didUpdateData: (() -> Void)?

	private var service: Service

	init(service: Service) {
		self.service = service
	}

	func start() {
		didUpdateData?()
	}

	func update(with service: Service) {
		self.service = service
		didUpdateData?()
	}
}


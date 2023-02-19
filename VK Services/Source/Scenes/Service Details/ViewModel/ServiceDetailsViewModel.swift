import Foundation
import UIKit

final class ServiceDetailsViewModel {

	var name: String {
		model.name
	}

	var description: String {
		model.description
	}

	var serviceUrl: String {
		model.serviceUrl
	}

	lazy var image: UIImage? = {
		guard let imageData = model.imageData else { return nil }
		return UIImage(data: imageData, scale: 0.05)
	}()

	weak var delegate: ServiceDetailsViewModelDelegate?

	var didUpdateData: (() -> Void)?
	var didReceiveError: (() -> Void)?

	private let dependencies: AppDependency
	private let model: Service

	init(dependencies: AppDependency, model: Service) {
		self.dependencies = dependencies
		self.model = model
	}

	func start() {
		didUpdateData?()
	}

	func finish() {
		delegate?.finish()
	}
}


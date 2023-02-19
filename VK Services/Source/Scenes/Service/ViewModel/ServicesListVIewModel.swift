import Foundation
import UIKit

final class ServicesListViewModel {
	var serviceViewModels: [ServiceCellViewModel] = []

	var didUpdateData: (() -> Void)?
	var didReceiveError: (() -> Void)?

	weak var delegate: ServicesListViewModelDelegate?

	private var pageNum = 1

	private let dependencies: AppDependency
	private var services: [Service] = []

	init(dependencies: AppDependency) {
		self.dependencies = dependencies
	}

	func start() {
		getServices(needRefresh: true)
	}

	func didSelectRow(at indexPath: IndexPath) {
		guard indexPath.row < services.count else { return }
		delegate?.showServiceDetails(with: services[indexPath.row])
	}

	private func getServices(needRefresh: Bool = false) {
		let jsonData = readLocalJSONFile(forName: "Result")
		if let data = jsonData {
			if let result = parse(jsonData: data) {
				self.handleSuccess(with: result)
			} else {
				self.handleError()
			}
		}
	}

	func parse(jsonData: Data) -> [Service]? {
		do {
			let decodedData = try JSONDecoder().decode(ServicesItems.self, from: jsonData)
			return decodedData.items
		} catch {
			self.handleError()
		}
		return []
	}
	
	func readLocalJSONFile(forName name: String) -> Data? {
		do {
			if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
				let fileUrl = URL(fileURLWithPath: filePath)
				let data = try Data(contentsOf: fileUrl)
				return data
			}
		} catch {
			self.handleError()
		}
		return nil
	}
	
	private func handleSuccess(with services: [Service]) {
		self.services += services
		serviceViewModels += services.map { convertToViewModel(service: $0) }
		didUpdateData?()
		loadImages(stringURLs: services.map { $0.iconUrl })
	}

	private func handleError() {
		didReceiveError?()
	}

	private func convertToViewModel(service: Service) -> ServiceCellViewModel {
		let cellViewModel = ServiceCellViewModel(service: service)
		return cellViewModel
	}

	private func loadImages(stringURLs: [String?]) {
		dependencies.networkManager.images(forURLs: stringURLs) { [weak self] imagesData in
			guard let self = self else { return }

			for (index, imageData) in imagesData.enumerated() {
				let indexWithOffset = (self.pageNum - 1) * 20 + index
				self.services[indexWithOffset].imageData = imageData
				self.serviceViewModels[indexWithOffset].update(with: self.services[indexWithOffset])
			}

			self.pageNum += 1
		}
	}
}


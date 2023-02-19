import UIKit

protocol ServiceDetailsViewModelDelegate: AnyObject {
	func finish()
}

final class ServiceDetailsCoordinator: Coordinator {
	var childCoordinators: [Coordinator]
	var rootNavigationController: UINavigationController

	var didOpenUrl: ((URL) -> Void)?
	var didReceiveError: (() -> Void)?

	weak var delegate: ServiceDetailsCoordinatorDelegate?

	private let dependencies: AppDependency
	private let service: Service

	init(
		dependencies: AppDependency,
		 rootNavigationController: UINavigationController,
		 service: Service) {
		self.dependencies = dependencies
		self.childCoordinators = []
		self.rootNavigationController = rootNavigationController
		self.service = service
	}

	func start() {
		let viewModel = ServiceDetailsViewModel(dependencies: dependencies, model: service)
		viewModel.delegate = self
		let vc = ServiceDetailsViewController(viewModel: viewModel)
		rootNavigationController.pushViewController(vc, animated: true)
	}
}

extension ServiceDetailsCoordinator: ServiceDetailsViewModelDelegate {
	func finish() {
		delegate?.finish(coordinator: self)
	}
}

import UIKit

protocol ServicesListViewModelDelegate: AnyObject {
	func showServiceDetails(with service: Service)
}

protocol ServiceDetailsCoordinatorDelegate: AnyObject {
	func finish(coordinator: ServiceDetailsCoordinator)
}

final class ServicesListCoordinator: Coordinator {
	var childCoordinators: [Coordinator]

	var rootNavigationController: UINavigationController

	private let dependencies: AppDependency

	init(dependencies: AppDependency,rootNavigationController: UINavigationController) {
		self.rootNavigationController = rootNavigationController
		self.dependencies = dependencies

		childCoordinators = []
	}

	func start() {
		let viewModel = ServicesListViewModel(dependencies: dependencies)
		viewModel.delegate = self
		let vc = ServicesListViewController(viewModel: viewModel)
		rootNavigationController.setViewControllers([vc], animated: true)
	}
}

extension ServicesListCoordinator: ServicesListViewModelDelegate {
	func showServiceDetails(with service: Service) {
		let serviceDetailsCoordinator = ServiceDetailsCoordinator(dependencies: dependencies,
																  rootNavigationController: rootNavigationController,
																  service: service)
		serviceDetailsCoordinator.delegate = self
		childCoordinators.append(serviceDetailsCoordinator)
		serviceDetailsCoordinator.start()
	}
}

extension ServicesListCoordinator: ServiceDetailsCoordinatorDelegate {
	func finish(coordinator: ServiceDetailsCoordinator) {
		removeAllChildCoordinatorsWithType(type(of: coordinator))
	}
}


import Foundation
import UIKit

final class ServicesListViewController: UIViewController {

	private let tableView = UITableView()

	private let viewModel: ServicesListViewModel

	init(viewModel: ServicesListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Сервисы"
		self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
		setupTableView()
		bindToViewModel()
		viewModel.start()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	private func setupTableView() {
		view.addSubview(tableView)
		tableView.register(ServiceCellView.self, forCellReuseIdentifier: ServiceCellView.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 90

		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}

	private func bindToViewModel() {
		viewModel.didUpdateData = { [weak self] in
			self?.tableView.reloadData()
		}

		viewModel.didReceiveError = { [weak self] in
			self?.showAlert(text: "Упс... Ошибка!")
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ServicesListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.serviceViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCellView", for: indexPath) as? ServiceCellView,
			indexPath.row < viewModel.serviceViewModels.count
		else {
			return UITableViewCell()
		}

		let cellViewModel = viewModel.serviceViewModels[indexPath.row]
		cell.selectionStyle = .none
		cell.configure(with: cellViewModel)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didSelectRow(at: indexPath)
	}
}

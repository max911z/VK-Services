import UIKit

class ServiceDetailsViewController: UIViewController {

	private let serviceImageView = UIImageView()
	private let serviceTitleLabel = UILabel()
	private let serviceDescriptionLabel = UILabel()
	private let goToAppLabel = UITextView()

	private let viewModel: ServiceDetailsViewModel

	init(viewModel: ServiceDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = self.viewModel.name
		setupLayout()
		bindToViewModel()
		viewModel.start()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		viewModel.finish()
	}

	private func bindToViewModel() {
		viewModel.didUpdateData = { [weak self] in
			guard let self = self else { return }

			self.serviceTitleLabel.text = self.viewModel.name
			self.serviceDescriptionLabel.text = self.viewModel.description
			self.goToAppLabel.text = self.viewModel.serviceUrl
			if let image = self.viewModel.image {
				self.serviceImageView.image = image
			}
		}

		viewModel.didReceiveError = { [weak self] in
			self?.showAlert(text: "Упс... Ошибка!")
		}
	}

	private func setupLayout() {
		view.backgroundColor = .systemBackground
		setupServiceImageView()
		setupServiceTitleLabel()
		setupServiceDescriptionLabel()
		setupGoToAppLabel()
	}

	private func setupServiceImageView() {
		view.addSubview(serviceImageView)

		serviceImageView.translatesAutoresizingMaskIntoConstraints = false
		serviceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		serviceImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
		serviceImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
		serviceImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
	}

	private func setupServiceTitleLabel() {
		view.addSubview(serviceTitleLabel)
		
		serviceTitleLabel.font = UIFont.boldSystemFont(ofSize: 34)
		serviceTitleLabel.textAlignment = .center
		serviceTitleLabel.adjustsFontSizeToFitWidth = true

		serviceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		serviceTitleLabel.topAnchor.constraint(equalTo: serviceImageView.bottomAnchor, constant: 30).isActive = true
		serviceTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}

	private func setupServiceDescriptionLabel() {
		view.addSubview(serviceDescriptionLabel)
		
		serviceDescriptionLabel.font = UIFont.systemFont(ofSize: 20)
		serviceDescriptionLabel.textAlignment = .center
		serviceDescriptionLabel.adjustsFontSizeToFitWidth = true
		serviceDescriptionLabel.lineBreakMode = .byWordWrapping
		serviceDescriptionLabel.numberOfLines = 0

		serviceDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		serviceDescriptionLabel.topAnchor.constraint(equalTo: serviceTitleLabel.bottomAnchor, constant: 30).isActive = true
		serviceDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		serviceDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
	}

	private func setupGoToAppLabel(){
		view.addSubview(goToAppLabel)

		let attributedString = NSMutableAttributedString(string: "Перейти в приложение")
		let url = URL(string: self.viewModel.serviceUrl)!
		attributedString.setAttributes([.link: url], range: NSMakeRange(0, 20))

		attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSRange(location: 0, length: 20))

		self.goToAppLabel.linkTextAttributes = [
			.foregroundColor: UIColor.blue,
			.underlineStyle: NSUnderlineStyle.single.rawValue
		]
		goToAppLabel.attributedText = attributedString
		goToAppLabel.isUserInteractionEnabled = true
		goToAppLabel.isEditable = false
		goToAppLabel.translatesAutoresizingMaskIntoConstraints = false
		goToAppLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
		goToAppLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
		goToAppLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		goToAppLabel.topAnchor.constraint(equalTo: serviceDescriptionLabel.bottomAnchor, constant: 16).isActive = true
	}
}

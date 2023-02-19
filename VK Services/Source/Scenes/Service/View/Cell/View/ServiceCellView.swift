import UIKit

class ServiceCellView: UITableViewCell {
	static let identifier = "ServiceCellView"
	
	private let serviceImageView = UIImageView()
	private let serviceTitleLabel = UILabel()
	private let arrow = UIImageView()

	private var viewModel: ServiceCellViewModel?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with viewModel: ServiceCellViewModel?) {
		self.viewModel = viewModel
		
		viewModel?.didUpdateData = { [weak self] in
			self?.serviceTitleLabel.text = viewModel?.name
			if let image = viewModel?.image {
				self?.serviceImageView.image = image
			}
		}
		viewModel?.start()
	}

	private func setupLayout(){
		setupServiceImageView()
		setupArrow()
		setupServiceTitleLabel()
	}

	private func setupServiceImageView(){
		contentView.addSubview(serviceImageView)

		serviceImageView.contentMode = .scaleAspectFit
		serviceImageView.image = UIImage(systemName: "paperplane.circle")
		serviceImageView.tintColor = .gray

		serviceImageView.translatesAutoresizingMaskIntoConstraints = false
		serviceImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		serviceImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
		serviceImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
		serviceImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
		serviceImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
		serviceImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
	}

	private func setupServiceTitleLabel(){
		contentView.addSubview(serviceTitleLabel)

		serviceTitleLabel.text = "text"
		serviceTitleLabel.font = .boldSystemFont(ofSize: 25)
		serviceTitleLabel.numberOfLines = 1

		serviceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		serviceTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		serviceTitleLabel.leadingAnchor.constraint(equalTo: serviceImageView.trailingAnchor, constant: 20).isActive = true
	}

	

	private func setupArrow(){
		contentView.addSubview(arrow)

		arrow.contentMode = .scaleAspectFit
		arrow.image = UIImage(named: "ButtonItem")

		arrow.translatesAutoresizingMaskIntoConstraints = false
		arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		arrow.widthAnchor.constraint(equalToConstant: 15).isActive = true
		arrow.heightAnchor.constraint(equalToConstant: 15).isActive = true
		arrow.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
	}
}


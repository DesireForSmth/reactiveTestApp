//
//  TableViewCell.swift
//  testReactiveApp
//
//  Created by Alexander Setrov on 29.03.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    weak var viewModel: CellViewModelProtocol?
    
    static let identifier = "ButtonStateCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setup(viewModel: CellViewModelProtocol) {
        self.viewModel = viewModel
        self.setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private lazy var containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .orange
        view.layer.cornerRadius = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.alpha = 0.8
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 25),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -25),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10)
        ])
    }

    private func setupUI() {
        self.contentView.addSubview(self.containerView)
        self.containerView.backgroundColor = .clear
        self.containerView.backgroundColor = self.viewModel?.getCellColor()
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.text = self.viewModel?.getCellTitle()
        self.setupConstraints()
    }

}


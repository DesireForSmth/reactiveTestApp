//
//  ViewController.swift
//  testReactiveApp
//
//  Created by Alexander Setrov on 29.03.2022.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {

    var viewModel: MainViewModelProtocol?

    var observer: Signal<UIButton, Never>.Observer?

    var disposableObserver: Disposable?

    public init(model: MainViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = model
        self.viewModel?.generateCellModels()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.observer = Signal<UIButton, Never>.Observer(value: { _ in
            print("event")
            self.view.setNeedsLayout()
            let (background, foreground) = (self.generateNewCellsButton.configuration?.baseBackgroundColor,
                           self.generateNewCellsButton.configuration?.baseForegroundColor)
            self.generateNewCellsButton.configuration?.baseBackgroundColor = foreground
            self.generateNewCellsButton.configuration?.baseForegroundColor = background
            self.view.layoutIfNeeded()
        })
        let signal = self.generateNewCellsButton.reactive.controlEvents(.touchUpInside).producer
        if let observer = self.observer {
            self.disposableObserver = signal.start(observer)
        }

//        self.viewModel?.modelsCountSignalProducerGenerator.producer
//            .startWithValues { value in
//                self.cellCountLabel.text = "Cell count: \(value)"
//            }
        self.viewModel?.mutableCellCollection.producer
            .skipRepeats()
            .startWithValues { array in
                self.tableView.reloadData()
                self.cellCountLabel.text = "Cell count: \(array.count)"
            }
        
    }

    private var cellCountLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "ButtonStateCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var generateNewCellsButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Generate cells"
        config.titleAlignment = .center
        config.titlePadding = 8
        config.baseBackgroundColor = .blue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config, primaryAction: nil)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(callGenerateCells), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc
    func callGenerateCells() {
        self.viewModel?.generateNewCellModels()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),

            self.generateNewCellsButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.generateNewCellsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),

            self.cellCountLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.cellCountLabel.bottomAnchor.constraint(equalTo: self.generateNewCellsButton.topAnchor, constant: -15)
        ])
    }

    private func setupUI() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.generateNewCellsButton)
        self.view.addSubview(self.cellCountLabel)
//        self.generateNewCellsButton.reactive.isHidden <~ viewModel?.isLoading
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.backgroundColor = .white
        self.tableView.separatorStyle = .none
//        self.tableView.backgroundColor = .white
        self.setupConstraints()
//        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//           return 1
//       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let viewModel = self.viewModel else {
            return 0
        }

        print("Cell count = \(viewModel.getCellModels().count)")
        return viewModel.getCellModels().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonStateCell", for: indexPath) as? TableViewCell else {
            return .init()
        }
//        guard let cellView = cell as? TableViewCell else {
//            return cell
//        }

        guard let cellModel = viewModel?.getCellModels()[indexPath.row] else {
            return cell
        }

        cell.setup(viewModel: cellModel)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    

}


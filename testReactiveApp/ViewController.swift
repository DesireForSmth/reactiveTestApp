//
//  ViewController.swift
//  testReactiveApp
//
//  Created by Alexander Setrov on 29.03.2022.
//

import UIKit
import ReactiveSwift

class ViewController: UIViewController {

    var viewModel: MainViewModelProtocol?

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
        // Do any additional setup after loading the view.
    }

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "ButtonStateCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setupUI() {
        self.view.addSubview(self.tableView)
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


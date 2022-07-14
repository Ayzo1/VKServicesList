//
//  ServicesViewController.swift
//  VKServicesList
//
//  Created by ayaz on 14.07.2022.
//

import UIKit

class ServicesViewController: UIViewController {
	
	// MARK: - Private properties
	
	var presenter: ServicesPresenterProtocol?
	var servicesTable: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.backgroundColor = Constants.secondBackgroundColor
		table.translatesAutoresizingMaskIntoConstraints = false
		table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		return table
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = Constants.secondBackgroundColor
		presenter = ServicesPresenter(view: self)
		
		servicesTable.delegate = self
		servicesTable.dataSource = self
		
		view.addSubview(servicesTable)
		setupTable()
		
        // Do any additional setup after loading the view.
    }
	
	private func setupTable() {
		servicesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		servicesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		servicesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		servicesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		//stocksTable.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
		//stocksTable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
	}
    
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.getServicesCount() ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard var cell = servicesTable.dequeueReusableCell(withIdentifier: "Cell") else {
			return UITableViewCell()
		}
		guard let service = presenter?.getService(for: indexPath.row) else {
			return UITableViewCell()
		}
		cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		cell.textLabel?.text = service.name
		cell.imageView?.image = UIImage(systemName: "person")
		cell.accessoryType = .disclosureIndicator
		cell.backgroundColor = Constants.secondBackgroundColor
		cell.textLabel?.textColor = Constants.textColor
		cell.detailTextLabel?.textColor = Constants.textColor
		cell.detailTextLabel?.lineBreakMode = .byWordWrapping
		cell.detailTextLabel?.numberOfLines = 0
		cell.detailTextLabel?.text = service.description
		
		
		return cell
	}
}

extension ServicesViewController: ServicesViewProtocol {
	func success() {
		DispatchQueue.main.async { [weak self] in
			print("fff")
			self?.servicesTable.reloadData()
		}
	}
	
	func failure(error: Error) {
		print("aaaa")
	}
}

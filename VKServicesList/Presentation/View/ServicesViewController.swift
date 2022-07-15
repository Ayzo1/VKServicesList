//
//  ServicesViewController.swift
//  VKServicesList
//
//  Created by ayaz on 14.07.2022.
//

import UIKit
import Kingfisher

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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = Constants.secondBackgroundColor
		presenter = ServicesPresenter(view: self)
		
		servicesTable.delegate = self
		servicesTable.dataSource = self
		setupNavigationBar()
		view.addSubview(servicesTable)
		setupTable()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        navigationItem.title = "Сервисы VK"
        navigationController?.navigationBar.barTintColor = Constants.secondBackgroundColor
        navigationController?.navigationBar.backgroundColor = Constants.secondBackgroundColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Constants.textColor]
    }
	
	private func setupTable() {
		servicesTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		servicesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		servicesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		servicesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}
    
    private func configurateCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        guard let service = presenter?.getService(for: indexPath.row) else {
            return cell
        }
        cell.textLabel?.text = service.name
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: cell.frame.height, height: cell.frame.height))
        cell.imageView?.kf.setImage(
            with: URL(string: service.iconURL),
            placeholder: UIImage(systemName: "person"),
            options: [.processor(processor), .cacheOriginalImage]) { result in
            switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    cell.layoutSubviews()
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
            }
        }
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

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.getServicesCount() ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let _ = servicesTable.dequeueReusableCell(withIdentifier: "Cell") else {
			return UITableViewCell()
		}
		return configurateCell(indexPath: indexPath)
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTap(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ServicesViewController: ServicesViewProtocol {
	func success() {
		DispatchQueue.main.async { [weak self] in
			self?.servicesTable.reloadData()
		}
	}
	
	func failure(error: Error) {
        print(error.localizedDescription)
	}
}

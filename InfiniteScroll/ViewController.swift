//
//  ViewController.swift
//  InfiniteScroll
//
//  Created by Saadet Şimşek on 05/08/2024.
//

import UIKit
import UIScrollView_InfiniteScroll

final class ViewController: UIViewController {
    
    let service = APICaller.shared
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        addConstraits()
        setupBinding()
    }
    
    private func addConstraits(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBinding(){
        
        service.fetchData { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        tableView.infiniteScrollDirection = .vertical
        
        tableView.addInfiniteScroll {[weak self] table in
            //fetch more data
            self?.service.loadMorePosts { [weak self] moreData in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    table.finishInfiniteScroll()
                }
                
            }
        }
    }
}
    
    extension ViewController: UITableViewDelegate, UITableViewDataSource{
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return service.models.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let model = service.models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model
            return cell
        }
    }


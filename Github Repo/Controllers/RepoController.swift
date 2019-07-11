//
//  RepoController.swift
//  Github Repo
//
//  Created by Suprianto Djamalu on 11/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import Kingfisher

class RepoController: UIViewController {

    var user: String!
    
    let viewModel = RepoViewModel(api: Api())
    let disposeBag = DisposeBag()
    
    var onLoaded = false
    var page = 1
    var repos = [Repo]()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let imgProfile: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "img_placeholder"))
        view.layer.cornerRadius = 130 / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    let lbName: UILabel = {
        let view = UILabel()
        view.text = "Loading name..."
        view.font = UIFont.systemFont(ofSize: 37)
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.isScrollEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getRepo(user: user, page: page)
        dataBinding()
        
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .white
        navigationItem.title = "Repository"
    
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    func dataBinding(){
        viewModel.repos.subscribe({ value in
            if value.element!.count > 0 {
                self.imgProfile.kf.setImage(with: URL(string: value.element![0].owner.avatarUrl))
                self.lbName.text = value.element![0].owner.login
                self.repos += value.element!
                
                self.onLoaded = false
            }
            
            self.tableView.reloadData()
            self.scrollView.contentSize.height = self.tableView.contentSize.height + 260
        }).disposed(by: disposeBag)
    }
    
    func setupView(){
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        scrollView.addSubview(imgProfile)
        scrollView.addSubview(lbName)
        scrollView.addSubview(tableView)
        
        imgProfile.snp.makeConstraints({ make in
            make.top.equalTo(scrollView.snp.top).offset(24)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.height.equalTo(130)
            make.width.equalTo(130)
        })
        
        lbName.snp.makeConstraints({ make in
            make.top.equalTo(imgProfile.snp.bottom).offset(35)
            make.centerX.equalTo(scrollView.snp.centerX)
        })
        
        tableView.snp.makeConstraints({ make in
            make.top.equalTo(lbName.snp.bottom).offset(30)
            make.leading.equalTo(scrollView.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        
    }
    
}

extension RepoController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = repos[indexPath.row].name
        return cell!
    }
}

extension RepoController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            
            if !onLoaded {
                onLoaded = true
                page += 1
                
                viewModel.getRepo(user: user, page: page)
            }
            
        }
        
    }
    
}

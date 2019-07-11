//
//  ViewController.swift
//  Github Repo
//
//  Created by Suprianto Djamalu on 11/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ViewController: UIViewController {
    
    let viewModel = RepoViewModel(api: Api())
    let disposeBag = DisposeBag()
    
    let lbSearch: UILabel = {
        let view = UILabel()
        view.text = "Search"
        view.textAlignment = .left
        return view
    }()
    
    let txSearch: UITextField = {
        let view = UITextField()
        view.placeholder = "Input Username"
        view.borderStyle = .roundedRect
        return view
    }()
    
    let btnSearch: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Search", for: .normal)
        view.addTarget(self, action: #selector(btnSearchTapped), for: .touchDown)
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .white
        navigationItem.title = "Github Repository"
        
        setupView()
        
        indicator.isHidden = true
        btnSearch.isHidden = false
    }
    
    @objc func btnSearchTapped(){
        
        if txSearch.text! != ""{
            self.btnSearch.isHidden = true
            self.indicator.isHidden = false
            
            viewModel.getRepo(user: txSearch.text!, page: 1)
        }
        
    }
    
    func dataBinding(){
        
        viewModel.repos.subscribe({ value in
            
            if value.element!.count > 0 && self.viewModel.didSearch {
                
                self.viewModel.didSearch = false
                self.viewModel.repoNotFound = false
                let vc = RepoController(nibName: nil, bundle: nil)
                vc.user = self.txSearch.text!
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            if self.viewModel.repoNotFound && self.viewModel.didSearch {
                
                self.viewModel.didSearch = false
                self.viewModel.repoNotFound = false
                
                self.btnSearch.isHidden = false
                self.indicator.isHidden = true
                
                let alert = UIAlertController(title: "Warning", message: "User not found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OKE", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                
            }
            
            if value.element!.count == 0 && self.viewModel.didSearch {
                self.viewModel.didSearch = false
                self.viewModel.repoNotFound = false
                
                self.btnSearch.isHidden = false
                self.indicator.isHidden = true
                
                let alert = UIAlertController(title: "Warning", message: "Repository empty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OKE", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
                        
        }).disposed(by: disposeBag)
        
    }

    func setupView(){
        
        view.addSubview(lbSearch)
        view.addSubview(txSearch)
        view.addSubview(btnSearch)
        view.addSubview(indicator)
        
        lbSearch.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
            make.leading.equalTo(view.snp.leading).offset(26)
        })
        
        txSearch.snp.makeConstraints({ make in
            make.top.equalTo(lbSearch.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(26)
            make.trailing.equalTo(view.snp.trailing).offset(-26)
        })
        
        btnSearch.snp.makeConstraints({ make in
            make.top.equalTo(txSearch.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        })
        
        indicator.snp.makeConstraints({ make in
            make.top.equalTo(txSearch.snp.bottom).offset(15)
            make.centerX.equalTo(view.snp.centerX)
        })
    }

}


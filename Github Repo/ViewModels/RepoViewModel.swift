//
//  RepoViewModel.swift
//  Github Repo
//
//  Created by Suprianto Djamalu on 11/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RepoViewModel {
    
    var api: Api!
    
    var repos = BehaviorRelay<[Repo]>(value: [])
    
    var didSearch = false
    var repoNotFound = false
    
    init(api: Api) {
        self.api = api
    }
    
    func getRepo(user: String, page: Int){
        
        api.fetchRepo(user: user, page: page, completion: { repos, err in
            
            self.didSearch = true
            
            if !err {
                self.repos.accept(repos!)
            }else{
                self.repoNotFound = true
                self.repos.accept([])
            }
            
        })
        
    }
    
}

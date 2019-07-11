//
//  Api.swift
//  Github Repo
//
//  Created by Suprianto Djamalu on 11/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation
import Alamofire

class Api {
    
    func fetchRepo(user: String, page: Int, completion: @escaping ([Repo]?, Bool) -> ()){
        
        AF.request("https://api.github.com/users/\(user)/repos?page=\(page)").responseJSON(completionHandler: { response in

            do {
                try completion(JSONDecoder().decode([Repo].self, from: response.data!), false)
            }catch let err{
                print(err)
                completion(nil, true)
            }
            
        })
        
    }
    
}

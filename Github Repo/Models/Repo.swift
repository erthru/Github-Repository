//
//  Repo.swift
//  Github Repo
//
//  Created by Suprianto Djamalu on 11/07/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation

struct Repo: Decodable {
    
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    
    private enum CodingKeys:String, CodingKey{
        case id
        case name
        case fullName = "full_name"
        case owner
    }
    
}

struct Owner: Decodable {
    
    let login: String
    let avatarUrl: String
    
    private enum CodingKeys:String, CodingKey{
        case login
        case avatarUrl = "avatar_url"
    }
    
}

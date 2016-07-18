//
//  Chain.swift
//  CookieCrunch
//
//  Created by 소프트가족 on 2016. 5. 20..
//  Copyright © 2016년 Bloc. All rights reserved.
//

import Foundation

class Chain: Hashable, CustomStringConvertible {
    var cookies = [Cookie]()
    var score = 0
    
    enum ChainType: CustomStringConvertible {
        case Horizontal
        case Vertical
        
        var description: String {
            switch self {
            case .Horizontal: return "Horiziontal"
            case .Vertical: return "vertical"
            }
        }
    }
    var chainType: ChainType
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func addCookie(cookie: Cookie) {
        cookies.append(cookie)
    }
    
    func firstCookie() -> Cookie {
        return cookies[0]
    }
    
    func lastCookie() -> Cookie {
        return cookies[cookies.count - 1]
    }
    
    var length: Int {
        return cookies.count
    }

    
    
    
    var description: String {
        return "type:\(chainType) cookies:\(cookies)"
    }
    
    var hashValue: Int {
        return cookies.reduce(0) { $0.hashValue ^ $1.hashValue }
    }
    
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.cookies == rhs.cookies
}
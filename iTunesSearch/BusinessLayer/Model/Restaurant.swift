//
//  Restaurant.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import Foundation

struct Restaurant: Decodable {
    let name: String
    let gender: String

    var displayText: String {
        return self.name + " - " + self.gender.capitalized
    }
}

//enum Cuisine: String, Decodable {
//    case european
//    case indian
//    case mexican
//    case french
//    case english
//}

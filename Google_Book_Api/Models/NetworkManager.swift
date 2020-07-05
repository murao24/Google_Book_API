//
//  NetworkManager.swift
//  Google_Book_Api
//
//  Created by 村尾慶伸 on 2020/07/05.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import Foundation
import Combine

class NerworkManager {

    var commponents: URLComponents {
        var commponents = URLComponents()
        commponents.scheme = "https"
        commponents.host = "www.googleapis.com"
        commponents.path = "/books/v1/volumes"
        commponents.queryItems = [URLQueryItem(name: "q", value: "マリアビートル")]
        return commponents
    }

    func fetchData() -> AnyPublisher<BookContainer, Error> {
        print(commponents.url!)
        return URLSession.shared.dataTaskPublisher(for: commponents.url!)
            .map { $0.data }
            .decode(type: BookContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

}

struct BookContainer: Decodable {
    let items: [Item]
}

struct Item: Decodable, Hashable {
    let volumeInfo: Book
}

struct Book: Decodable, Hashable {
    let title: String
    let authors: [String]
}

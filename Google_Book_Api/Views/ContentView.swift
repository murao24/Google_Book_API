//
//  ContentView.swift
//  Google_Book_Api
//
//  Created by 村尾慶伸 on 2020/07/05.
//  Copyright © 2020 村尾慶伸. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {

    @ObservedObject var bookListVM = BookListViewModel()

    var body: some View {
        List(bookListVM.bookViewModels, id: \.self) { bookViewModel in
            Text(bookViewModel.displayText)
        }
        .onAppear {
            self.bookListVM.fetchData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class BookListViewModel: ObservableObject {

    private let networkManager = NerworkManager()

    @Published var bookViewModels = [BookViewModel]()

    var cancellable: AnyCancellable?

    func fetchData() {
        cancellable = networkManager.fetchData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }, receiveValue: { bookContainer in
                self.bookViewModels = bookContainer.items.map {
                    BookViewModel($0)
                }
            })
    }

}

struct BookViewModel: Hashable {

    private let item: Item

    var title: String {
        return item.volumeInfo.title
    }

    var authors: [String] {
        return item.volumeInfo.authors
    }

    var displayText: String {
        return title + "-" + authors[0]
    }

    init(_ item: Item) {
        self.item = item
    }

}

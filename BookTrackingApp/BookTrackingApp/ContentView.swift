//
//  ContentView.swift
//  BookTrackingApp
//
//  Created by Amezcua, Bella G on 4/15/24.
//

            

import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    var title: String
    var imageName: String?
}

struct ContentView: View {
    @State private var currentBook: Book? = nil
    @State private var addingBook = false
    @State private var selectedBook: Book? = nil

    var body: some View {
        TabView {
            MyBooksView(currentBook: $currentBook, addingBook: $addingBook, selectedBook: $selectedBook)
                .tabItem {
                    Image(systemName: "book")
                    Text("My Books")
                }
            LibraryView(currentBook: $currentBook, addingBook: $addingBook, selectedBook: $selectedBook)
                .tabItem {
                    Image(systemName: "archivebox")
                    Text("Library")
                }
            RecommendationsView(currentBook: $currentBook, addingBook: $addingBook, selectedBook: $selectedBook)
                .tabItem {
                    Image(systemName: "star")
                    Text("Recommendations")
                }
        }
    }
}

struct MyBooksView: View {
    @Binding var currentBook: Book?
    @Binding var addingBook: Bool
    @Binding var selectedBook: Book?

    // Mock progress value for demonstration
    @State private var progress: Double = 0.6 // Example progress value
    @State private var currentPage: Int = 288 // Example current page

    var body: some View {
        ScrollView {
            VStack {
                
                
                Text("Book Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer() // Spacer to push content to the Top

                Text("Reading Progress")
                    .font(.title)
                                        .padding()

                if let book = currentBook {
                    if let imageName = book.imageName {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .padding()
                    } else {
                        Text("No Image Available")
                            .padding()
                    }

                    Text("Currently Reading:")
                        .font(.title)
                        .padding()

                    Text("\(book.title)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()

                    // Combined progress bar and page number slider
                    VStack {
                        HStack {
                            Text("Page: \(currentPage)")
                                .padding(.top, 10)
                            Spacer()
                        }
                        Slider(value: $progress, in: 0...1, step: 0.001)
                            .padding(.horizontal)
                            .onChange(of: progress) { newValue in
                                currentPage = Int(newValue * 480)
                            }
                    }
                    .padding(.horizontal)

                } else {
                    Spacer() // Spacer to push content to the bottom
                    Text("No book currently being read.")
                        .font(.title)
                        .padding()
                }

                Button(action: {
                    addingBook = true
                }) {
                    Text("Add Book")
                }
                .padding()
                
                Spacer() // Spacer to push content to the bottom
                
            }
        }
        .sheet(isPresented: $addingBook) {
            AddBookView(isPresented: $addingBook, selectedBook: $selectedBook, currentBook: $currentBook)
        }
    }
}

struct AddBookView: View {
    @Binding var isPresented: Bool
    @Binding var selectedBook: Book?
    @Binding var currentBook: Book?

    let books = [
        Book(title: "Powerless by Lauren Roberts", imageName: "powerless"),
        Book(title: "Normal People by Sally Rooney", imageName: "normal"),
        Book(title: "The Bell Jar by Sylvia Plath", imageName: "belljar"),
        Book(title: "Binding 13 by Chloe Walsh", imageName: "binding"),
        Book(title: "Pretty Girls by Karin Slaughter", imageName: "pretty"),
        Book(title: "Bride by Ali Hazelwood", imageName: "bride")
    ]

    var body: some View {
        NavigationView {
            List(books, id: \.title) { book in
                Button(action: {
                    selectedBook = book
                    currentBook = book
                    isPresented = false
                }) {
                    LibraryRow(book: book)
                }
            }
            .navigationTitle("Add Book")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct LibraryRow: View {
    let book: Book

    var body: some View {
        VStack {
            if let imageName = book.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
            } else {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
            }

            Text(book.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
    }
}

struct LibraryView: View {
    @Binding var currentBook: Book?
    @Binding var addingBook: Bool
    @Binding var selectedBook: Book?
    @State private var searchText = ""

    let books = [
        Book(title: "Powerless by Lauren Roberts", imageName: "powerless"),
        Book(title: "Normal People by Sally Rooney", imageName: "normal"),
        Book(title: "The Bell Jar by Sylvia Plath", imageName: "belljar"),
        Book(title: "Binding 13 by Chloe Walsh", imageName: "binding"),
        Book(title: "Pretty Girls by Karin Slaughter", imageName: "pretty"),
        Book(title: "Bride by Ali Hazelwood", imageName: "bride")
    ]

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)

                ScrollView {
                                   LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 16) {
                                       ForEach(filteredBooks, id: \.id) { book in
                                           LibraryItemView(book: book)
                                       }
                                   }
                                   .padding()
                }
            }
            .navigationTitle("My Library")
        }
    }
}
struct LibraryItemView: View {
    let book: Book

    var body: some View {
        VStack {
            if let imageName = book.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
            } else {
                Image(systemName: "book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
            }

            Text(book.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
    }
}
struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: {
                searchText = "" // Clear the search text
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
        }
    }
}


struct RecommendationsView: View {
    @Binding var currentBook: Book?
    @Binding var addingBook: Bool
    @Binding var selectedBook: Book?

    let recommendedBooks = [
        Book(title: "A Court of Thorns and Roses by Sarah J. Mass", imageName: "acotar"),
        Book(title: "A Good Girl's Guide to Murder by Holly Jackson", imageName: "agggtm"),
        Book(title: "Persuasion by Jane Austen", imageName: "persuasion"),
        Book(title: "Fourth Wing by Rebecca Yarros", imageName: "fourth"),
        Book(title: "Bunny by Mona Awad", imageName: "bunny"),
        Book(title: "Then She Was Gone by Lisa Jewell", imageName: "tswg")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("If you like these books you will also love...")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                ForEach(recommendedBooks) { book in
                    VStack {
                        if let imageName = book.imageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                        } else {
                            Image(systemName: "book")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                        }

                        Text(book.title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)

                        Button(action: {
                            // Perform the action to add the book to the library
                            selectedBook = book
                            currentBook = book
                            addingBook = true
                        }) {
                            Text("Add to Library")
                                .foregroundColor(.blue)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $addingBook) {
            // Present the AddBookView when addingBook is true
            AddBookView(isPresented: $addingBook, selectedBook: $selectedBook, currentBook: $currentBook)
        }
        .navigationTitle("Recommendations")
    }
}

    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

            



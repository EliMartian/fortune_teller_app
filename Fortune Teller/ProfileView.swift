//
//  ProfileView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import Foundation
import SwiftUI
import CoreData

struct ProfileView: View {
    @ObservedObject var selectedAuthorsManager = SelectedAuthorsManager()
    @State private var authors: [String] = []
    @State private var displayedQuotes: [String: [String]] = [:]

    var body: some View {
            NavigationView {
                VStack {
                    Text("Profile")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding()

                    // Display toggle switches for each author
                    ScrollView {
                        ForEach(authors, id: \.self) { author in
                            Toggle(isOn: Binding(
                                get: { self.selectedAuthorsManager.selectedAuthors.contains(author) },
                                set: { isSelected in
                                    self.selectedAuthorsManager.toggleAuthorSelection(author)
                                }
                            )) {
                                Text(author)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)

                    Spacer()

                    // Button to load and display selected quotes
                    Button(action: {
                        loadAndDisplayQuotes()
                    }) {
                        Text("View Selected Quotes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .padding()

                    // Display quotes under each author
                    List {
                        ForEach(displayedQuotes.sorted(by: { $0.key < $1.key }), id: \.key) { author, quotes in
                            Section(header: Text(author)) {
                                ForEach(quotes, id: \.self) { quote in
                                    Text("- \(quote)")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
                .padding()
                .onAppear {
                    loadAuthorsFromPlist()
                }
                .navigationTitle("Authors")
            }
        }

    private func loadAuthorsFromPlist() {
        guard let loadedAuthors = DataLoader.loadQuotesFromPlist(named: "investor_quotes") else {
            print("Failed to load authors from plist.")
            return
        }
        authors = Array(loadedAuthors.keys)
    }

    private func loadAndDisplayQuotes() {
        let selectedAuthors = Array(selectedAuthorsManager.selectedAuthors)
                
        // Use DataLoader to load example quotes from plist
        DataLoader.loadExampleQuotes(for: selectedAuthors, in: PersistenceController.shared.container.viewContext)

        // Fetch quotes for selected authors from Core Data
        var quotesByAuthors: [String: [String]] = [:]

        // Create a fetch request to retrieve quotes for selected authors
        let fetchRequest: NSFetchRequest<Quote> = Quote.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author IN %@", selectedAuthors)

        do {
            let quotes = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)

            // Group quotes by author
            for quote in quotes {
                let author = quote.author ?? ""
                let quoteText = quote.text ?? ""

                if quotesByAuthors[author] == nil {
                    quotesByAuthors[author] = []
                }

                // Check if quote text is already in the array to avoid duplication
                if !quotesByAuthors[author]!.contains(quoteText) {
                    quotesByAuthors[author]?.append(quoteText)
                }
            }

            // Now quotesByAuthors dictionary contains quotes grouped by authors
            displayedQuotes = quotesByAuthors
        } catch {
            print("Error fetching quotes: \(error.localizedDescription)")
        }
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


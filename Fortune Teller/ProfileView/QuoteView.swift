//
//  QuoteView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/18/24.
//

import Foundation
import SwiftUI
import CoreData

struct QuoteView: View {
    @ObservedObject var selectedAuthorsManager = SelectedAuthorsManager()
    @State private var authors: [String] = []
    @State private var displayedQuotes: [String: [String]] = [:]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("My Profile")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding()

                    // Display toggle switches for each author
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(authors, id: \.self) { author in
                                    Toggle(isOn: Binding(
                                        get: { self.selectedAuthorsManager.selectedAuthors.contains(author) },
                                        set: { isSelected in
                                            self.selectedAuthorsManager.toggleAuthorSelection(author)
                                        }
                                    )) {
                                        Text(author)
                                            .foregroundColor(Color("DarkGrey"))
                                    }
                                    .padding()
                                    .background(Color("LightestGrey"))
                                    .cornerRadius(8)
                                    .fixedSize(horizontal: false, vertical: false) // Allow wrapping for long author names
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 40) // Adjust vertical padding
                            .background(Color("LightGrey"))
                            .cornerRadius(20) // Apply corner radius to the content container
                            .frame(width: geometry.size.width * 0.9) // Limit width to 90% of available width
                            .frame(height: calculateScrollViewHeight(authors: authors, maxHeight: geometry.size.height * 0.8)) // Adjust height based on number of authors and available space
                        }
                    }
                    .padding()

                    Spacer() // Pushes the button to the bottom

                    // Button to load and display selected quotes
                    Button(action: {
                        loadAuthorsAndQuotes()
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
                    .padding()
                }
                .onAppear {
                    loadAuthorsFromPlist()
                }
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Full black background
        }

        

    }
    
    // Helper function to calculate the necessary height for the ScrollView
    private func calculateScrollViewHeight(authors: [String], maxHeight: CGFloat) -> CGFloat {
        let rowHeight: CGFloat = 60 // Adjust the row height as needed
        let totalAuthorsHeight = CGFloat(authors.count) * rowHeight
        let paddingHeight: CGFloat = 50 // Vertical padding around the ScrollView content
        let containerHeight = totalAuthorsHeight + paddingHeight
        return min(containerHeight, maxHeight) // Limit height to the available maximum height
    }

    private func loadAuthorsFromPlist() {
        guard let loadedAuthors = DataLoader.loadQuotesFromPlist(named: "investor_quotes") else {
            print("Failed to load authors from plist.")
            return
        }
        authors = Array(loadedAuthors.keys)
    }

    private func loadAuthorsAndQuotes() {
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


struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}

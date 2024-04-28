//
//  DataLoader.swift
//  Fortune Teller
//
//  Created by E Martin on 4/17/24.
//

import Foundation
import CoreData
import UIKit

class DataLoader {
    static func loadQuotesFromPlist(named plistName: String) -> [String: [String]]? {
        guard let plistURL = Bundle.main.url(forResource: plistName, withExtension: "plist") else {
            print("Failed to locate \(plistName).plist in bundle resources")
            return nil
        }
        
        do {
            // Load the data from the plist file
            let plistData = try Data(contentsOf: plistURL)
            print("Size of plistData:", plistData.count, "bytes")

            // Deserialize the plist data into a dictionary
            guard let plistObject = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else {
                print("Failed to deserialize \(plistName).plist into dictionary format")
                return nil
            }

            // Prepare a dictionary to hold quotes by authors
            var quotesByAuthors: [String: [String]] = [:]

            // Extract quotes for each author from the plist object
            for (author, quotesArray) in plistObject {
                if let quotes = quotesArray as? [String] {
                    quotesByAuthors[author] = quotes
                }
            }

            // Print the extracted quotes for debugging
            print("Quotes loaded successfully:")
            for (author, quotes) in quotesByAuthors {
                print("Author:", author)
                for (index, quote) in quotes.enumerated() {
                    print("Quote \(index):", quote)
                }
            }

            return quotesByAuthors
        } catch {
            print("Error loading \(plistName).plist: \(error.localizedDescription)")
            return nil
        }
    }

    static func loadExampleQuotes(for authors: [String], in context: NSManagedObjectContext) {
        guard let quotesByAuthors = loadQuotesFromPlist(named: "investor_quotes") else {
            print("Failed to load example quotes.")
            return
        }

        for author in authors {
            if let quoteItems = quotesByAuthors[author] {
                for quoteText in quoteItems {
                    if let quote = NSEntityDescription.insertNewObject(forEntityName: "Quote", into: context) as? Quote {
                        quote.text = quoteText
                        quote.author = author

                        // Print the quote information
                        print("Quote: \(quoteText) by \(author)")
                    }
                }
            }
        }

        do {
            // Save in core data
            try context.save()
            print("Quotes loaded successfully!")
        } catch {
            print("Error saving quotes: \(error.localizedDescription)")
        }
    }
    
}

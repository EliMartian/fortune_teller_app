//
//  SelectedAuthorsManager.swift
//  Fortune Teller
//
//  Created by E Martin on 4/18/24.
//

import Foundation
import SwiftUI


class SelectedAuthorsManager: ObservableObject {
    @Published var selectedAuthors: Set<String> = [] {
        didSet {
            saveSelectedAuthors()
        }
    }
    
    private let selectedAuthorsKey = "SelectedAuthors"
    
    init() {
        loadSelectedAuthors()
    }
    
    private func saveSelectedAuthors() {
        let data = Array(selectedAuthors)
        UserDefaults.standard.set(data, forKey: selectedAuthorsKey)
    }
    
    private func loadSelectedAuthors() {
        if let data = UserDefaults.standard.array(forKey: selectedAuthorsKey) as? [String] {
            selectedAuthors = Set(data)
        } else {
            // Handle case where no data is found or data is of unexpected type
            print("Failed to load selected authors from UserDefaults.")
        }
    }
    
    func toggleAuthorSelection(_ author: String) {
        DispatchQueue.main.async {
            if self.selectedAuthors.contains(author) {
                self.selectedAuthors.remove(author)
            } else {
                self.selectedAuthors.insert(author)
            }
        }
    }
}


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
        }
    }
    
    func toggleAuthorSelection(_ author: String) {
        if selectedAuthors.contains(author) {
            selectedAuthors.remove(author)
        } else {
            selectedAuthors.insert(author)
        }
    }
}


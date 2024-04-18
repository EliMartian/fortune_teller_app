//
//  SelectedAuthorsManager.swift
//  Fortune Teller
//
//  Created by E Martin on 4/18/24.
//

import Foundation
import SwiftUI

class SelectedAuthorsManager: ObservableObject {
    @Published var selectedAuthors: Set<String> = []

    func toggleAuthorSelection(_ author: String) {
        if selectedAuthors.contains(author) {
            selectedAuthors.remove(author)
        } else {
            selectedAuthors.insert(author)
        }
    }
}

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
    @State private var profileImage: UIImage? // State variable to hold the loaded profile image

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                Text("Profile")
                    .font(.title)
                    .foregroundColor(.green)
                
                
                
                VStack {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64) // Size of the profile image icon
                            .clipShape(Circle())
                            .padding(.top, 20) // Top padding for the profile image icon
                    }
                    
                    VStack {
                        Spacer()
                        NavigationLink(destination: QuoteView()) {
                            ProfileOptionRow(title: "Quotes")
                        }
                        .padding()
                        .background(Color("LightestGrey"))

                        NavigationLink(destination: ProfilePictureView()) {
                            ProfileOptionRow(title: "Profile Picture")
                        }
                        .padding()
                        .background(Color("LightestGrey"))

                        Spacer()
                    }
//
                }

                .onAppear {
                    loadProfileImage() // Load the profile image when the view appears
                }
            }
        }
    }
    
    // Function to load the saved profile image
    private func loadProfileImage() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("selectedImage.jpg")
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            self.profileImage = UIImage(data: imageData)
        } catch {
            print("Error loading profile image: \(error.localizedDescription)")
        }
    }
}

struct ProfileOptionRow: View {
    var title: String

    var body: some View {
        ZStack {
            HStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .padding()
            }
            .padding()
        }
        .frame(height: 80)
        .background(Color("LightGrey"))
        .cornerRadius(16)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

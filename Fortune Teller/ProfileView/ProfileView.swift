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
    var body: some View {
        NavigationLink(destination: QuoteView()) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Profile")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Spacer()
                }
                
                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(Color("LightGrey"))
                                    .frame(height: 80) // Adjust height as needed
                HStack {
                    Text("Quotes")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
    }
                
//                RoundedRectangle(cornerRadius: 16)
//                    .foregroundColor(Color("LightGrey"))
//                    .frame(height: 80) // Adjust height as needed

//                HStack {
//                    Text("My Profile")
//                        .font(.title)
//                        .foregroundColor(.green)
//                        .padding()
//
//                    Spacer()
//
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.black)
//                        .padding()
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Profile")
//        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation style to avoid
//    }
//    var body: some View {
//            NavigationLink(destination: QuoteView()) {
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    
//                    RoundedRectangle(cornerRadius: 16)
//                        .foregroundColor(Color("LightGrey"))
//                        .frame(height: 80) // Adjust height as needed
//
//                    HStack {
//                        Text("My Profile")
//                            .font(.title)
//                            .foregroundColor(.green)
//                            .padding()
//                        
//                        Spacer()
//                        
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.black)
//                            .padding()
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("Profile")
//        }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

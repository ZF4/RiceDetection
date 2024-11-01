//
//  HomeView.swift
//  RiceDetectionApp
//
//  Created by Zachary Farmer on 10/24/24.
//

import SwiftUI

struct HomeView: View {
    @State private var detectedImage: UIImage?
    @State private var selectedPhoto: UIImage?
    @State private var predictions: [String: Any] = [:]
    @State private var isLoading = false
    @State private var photoPicked = false
    @State private var errorMessage: String?
    private var width = UIScreen.main.bounds.width
    private var height = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                Text("TradeWinds Grain Scanner")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if let image = detectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: width - 50, height: 300)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    VStack {
                        AddPhoto(selectedPhoto: $selectedPhoto)
                            .padding(.horizontal)
                    }
                    .frame(width: width, height: 300)
                }
                
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    HStack {
                        Button(action: { resetPhoto() }) {
                          Text("Reset Photo")
                            .padding()
                            .foregroundColor(.white)
                            .background(photoPicked ? .orange : .gray)
                            .cornerRadius(10)
                        }
                        .disabled(!photoPicked)
                        
                        Button(action: { detectRice() }) {
                          Text("Scan Photo")
                            .padding()
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(10)
                        }
                    }
                }
                
                if !predictions.isEmpty {
                    Text("Predictions:")
                        .foregroundStyle(Color.black)
                    Text(predictions.description)
                        .foregroundStyle(Color.black)
                }
                Spacer()
            }
            .onChange(of: selectedPhoto) {
                photoPicked.toggle()
            }
            .padding(.top, 75)
        }
        .ignoresSafeArea()
    }
    
    private func resetPhoto() {
        detectedImage = nil
        selectedPhoto = nil
        errorMessage = nil
        predictions = [:]
    }
    
    private func detectRice() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let (predictions, image) = try await MainDetection.detectRice(imageName: selectedPhoto)
                self.predictions = predictions
                self.detectedImage = image
            } catch {
                self.errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

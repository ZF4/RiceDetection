// RiceDetectionApp/Views/HomeView.swift
//
//  HomeView.swift
//  RiceDetectionApp
//
//  Created by Zachary Farmer on 10/24/24.
//

import SwiftUI

struct HomeView: View {
    @State private var detectedColorImage: UIImage?
    @State private var detectedSizeImage: UIImage?
    @State private var selectedPhoto: UIImage?
    @State private var sizePredictions: [Prediction] = []
    @State private var colorPredictions: [Prediction] = []
    @State private var isLoading = false
    @State private var photoPicked = false
    @State private var showSelector = false
    @State private var errorMessage: String?
    @State private var selectedImageType = "Size"
    
    private var width = UIScreen.main.bounds.width
    private let imageTypes = ["Size", "Color"]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.white
            VStack {
                // Top panel
                Image("logo")
                    .resizable()
                    .frame(width: 125, height: 40)
                
                imageDisplaySection
                
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    errorSection(error: error)
                }
                
                if showSelector {
                    imageTypeSelector
                }
                                
                // Middle panel
                actionButtons
                
                Divider()
                
                // Bottom panel
                statsSection
                Spacer()
            }
            .padding(.top, 55)
        }
        .ignoresSafeArea()
        .onChange(of: selectedPhoto) { photoPicked.toggle() }
    }
    
    private var imageDisplaySection: some View {
        Group {
            if let detectedSizeImage = detectedSizeImage, selectedImageType == "Size" {
                imageView(image: detectedSizeImage)
                    .onAppear {
                        showSelector = true
                    }
            } else if let detectedColorImage = detectedColorImage, selectedImageType == "Color" {
                imageView(image: detectedColorImage)
                    .onAppear {
                        showSelector = true
                    }
            } else if let image = selectedPhoto {
                imageView(image: image)
            } else {
                placeholderImage
            }
        }
    }
    
    private func imageView(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: width - 50, height: 300)
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var placeholderImage: some View {
        AddPhoto(selectedPhoto: $selectedPhoto)
    }
    
    private func errorSection(error: String) -> some View {
        VStack {
            Text(error)
                .foregroundColor(.red)
            Button(action: resetPhoto) {
                Text("Try again")
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(10)
            }
        }
    }
    
    private var imageTypeSelector: some View {
        VStack {
            Text("Select Image Type")
            Picker("", selection: $selectedImageType) {
                ForEach(imageTypes, id: \.self) { image in
                    Text(image)
                }
            }
            .pickerStyle(.segmented)
        }
        .frame(width: width - 50)
    }
    
    private var statsSection: some View {
        ScrollView {
            VStack(alignment: .leading) {
                //MARK: REMOVED AREA FOR NOW
//                Text("Area:")
//                    .fontWeight(.bold)
//                    .foregroundStyle(Color.black)
//                Text(totalArea())
//                    .foregroundStyle(Color.black)
                
                Text("Count:")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                Text(totalRiceCount())
                    .foregroundStyle(Color.black)
                
//                Text("Count by color:")
//                    .fontWeight(.bold)
//                    .foregroundStyle(Color.black)
//                Text(totalRiceCount())
//                    .foregroundStyle(Color.black)
            }
            .padding(.horizontal)
        }
    }
    
    private var actionButtons: some View {
        HStack {
            resetButton
            scanButton
        }
        .padding()
    }
    
    private var resetButton: some View {
        Button(action: resetPhoto) {
            Image(systemName: "arrow.circlepath")
                .padding()
                .foregroundColor(.white)
                .background(photoPicked ? .orange : .gray)
                .clipShape(Circle())
        }
    }
    
    private var scanButton: some View {
        Button(action: detectRice) {
            Image(systemName: "arrow.up")
                .padding()
                .foregroundColor(.white)
                .background(photoPicked ? .green : .gray)
                .clipShape(Circle())
                .disabled(showSelector)

        }
    }
    
    private func resetPhoto() {
        detectedSizeImage = nil
        selectedPhoto = nil
        errorMessage = nil
        sizePredictions = []
        colorPredictions = []
        showSelector = false
    }
    
        //MARK: REMOVED AREA FOR NOW
//    private func totalArea() -> String {
//        var totalArea = 0
//        var headRiceArea = 0
//        var brewersArea = 0
//        var brokenArea = 0
//        
//        for prediction in sizePredictions {
//            let area = prediction.width * prediction.height
//            totalArea += area
//            
//            switch prediction.className {
//            case "head rice":
//                headRiceArea += area
//            case "brewers":
//                brewersArea += area
//            case "broken":
//                brokenArea += area
//            default:
//                break
//            }
//        }
//        
//        // Calculate percentages
//        let headRicePercentage = totalArea > 0 ? (Double(headRiceArea) / Double(totalArea)) * 100 : 0
//        let brewersPercentage = totalArea > 0 ? (Double(brewersArea) / Double(totalArea)) * 100 : 0
//        let brokenPercentage = totalArea > 0 ? (Double(brokenArea) / Double(totalArea)) * 100 : 0
//        
//        return String(format: "Head Rice: %.2f%%, Brewers: %.2f%%, Broken: %.2f%%",
//                       headRicePercentage, 
//                       brewersPercentage, 
//                       brokenPercentage)
//    }
    
    private func totalCount() -> String {
        var counts: [String: Int] = ["head": 0, "broken": 0]
        
        for prediction in sizePredictions {
            switch prediction.className {
            case "head":
                counts["head", default: 0] += 1
            case "broken":
                counts["broken", default: 0] += 1
            default:
                break
            }
        }
        
        let totalCount = counts.values.reduce(0, +)
        
        // Calculate percentages
        let headRicePercentage = totalCount > 0 ? (Double(counts["head"]!) / Double(totalCount)) * 100 : 0
        let brokenPercentage = totalCount > 0 ? (Double(counts["broken"]!) / Double(totalCount)) * 100 : 0
        
        return String(format: "Head Rice: %.2f%%, Brokens: %.2f%%",
                       headRicePercentage,
                       brokenPercentage)
    }
    
    private func totalRiceCount() -> String {
        var counts: [String: Int] = ["head": 0, "broken": 0]
        
        for prediction in sizePredictions {
            switch prediction.className {
            case "head":
                counts["head", default: 0] += 1
            case "broken":
                counts["broken", default: 0] += 1
            default:
                break
            }
        }
        
        let totalCount = counts.values.reduce(0, +)
        
        return String(format: "Total: %d, Head Rice: %d, Broken Rice: %d",
                       totalCount,
                       counts["head"]!,
                       counts["broken"]!)
    }
    
    private func detectRice() {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                let predictionsFromSizeJSON = try await MainDetection.returnSizeJSONfromImage(imageName: selectedPhoto)
                let predictionsFromColorJSON = try await MainDetection.returnColorJSONfromImage(imageName: selectedPhoto)
                let sizeImage = try await MainDetection.returnSizeImagefromImage(imageName: selectedPhoto)
                let colorImage = try await MainDetection.returnColorImagefromImage(imageName: selectedPhoto)
                self.sizePredictions = predictionsFromSizeJSON
                self.colorPredictions = predictionsFromColorJSON
                self.detectedSizeImage = sizeImage
                self.detectedColorImage = colorImage
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

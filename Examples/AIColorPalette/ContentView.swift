//
//  ContentView.swift
//  AIColorPalette
//
//  Created by Todd Hamilton on 6/20/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {

    @State private var presentSheet = false
    @State private var sheetColor:ColorData = ColorData(red: 1.0, green:1.0, blue:1.0)
    @State private var copiedToClipboard = false

    @State var counter: Int = 0
    @State var origin: CGPoint = .zero

    @State private var sampleImage: UIImage? = UIImage(named: "palm")
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var loading = false
    @State private var loadingIndicator = false
    @State private var sampleColors:Colors = Colors(
        colors:
            [
                ColorData(red: 0.28, green: 0.28, blue: 0.20),
                ColorData(red: 0.72, green: 0.75, blue: 0.73),
                ColorData(red: 0.08, green: 0.54, blue: 0.63),
                ColorData(red: 0.59, green: 0.49, blue: 0.35)
            ]
    )

    var body: some View {

        ZStack{
            MeshGradient(
                width: 2,
                height: 2,
                points: [
                    [0, 0], [1, 0],
                    [0, 1], [1, 1],
                ], colors: createMeshColors())
            .ignoresSafeArea()

            VStack(spacing:48){

                // Sample image
                Image(uiImage: sampleImage!)
                    .resizable()
                    .scaledToFill()
                    .modifier(RippleEffect(at: origin, trigger: counter))
                    .frame(maxWidth:320, maxHeight:360)
                    .cornerRadius(24)
                    .clipped()
                    .shadow(radius: 10)
                    .overlay(
                        ZStack{
                            Color
                                .black
                                .opacity(0.75)
                            Text("Generating palette...")
                                .bold()
                                .foregroundStyle(.white)
                        }
                            .cornerRadius(24)
                            .clipped()
                            .opacity(loadingIndicator ? 1 : 0)
                    )

                VStack(spacing: 48){
                    ZStack{
                        // Color swatches
                        HStack(spacing:loading ? -60 : 20){
                            ForEach(Array(sampleColors.colors.enumerated()), id: \.offset) { index, color in
                                Circle()
                                    .stroke(.white, lineWidth: 8)
                                    .fill(Color(red: color.red,green: color.green,blue: color.blue))
                                    .frame(width:60)
                                    .onTapGesture {
                                        sheetColor = color
                                        presentSheet.toggle()
                                    }
                            }
                        }

                        if loadingIndicator{
                            Circle()
                                .fill(.white)
                                .stroke(.white, lineWidth:8)
                                .frame(width:60)
                                .overlay(
                                    ProgressView()
                                        .tint(.black)
                                )
                        }
                    }

                    PhotosPicker(selection: $photosPickerItem, matching: .images){
                        Text("Choose Photo")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .controlSize(.extraLarge)
                }

            }

        }
        .sheet(isPresented: $presentSheet) {
            ColorDetailView(currentColor: $sheetColor)
                .presentationDetents([.medium])
                .presentationBackground(.thickMaterial)

        }
        .onChange(of: photosPickerItem){ _, _ in
            Task{
                loading = true
                loadingIndicator = true
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self){
                    if let image = UIImage(data: data){
                        withAnimation(){
                            sampleImage = image
                        }
                        try await generateColorPalette(image: sampleImage!)
                    }
                }
                withAnimation(){
                    loading = false
                }
                withAnimation(.bouncy){
                    loadingIndicator = false
                }
                counter += 1
            }
        }

    }

    func createMeshColors() -> [Color] {
        var meshColors: [Color] = []
        for color in sampleColors.colors {
            meshColors.append(Color(red: color.red, green: color.green, blue: color.blue))
        }
        return meshColors
    }

    func generateColorPalette(image: UIImage) async throws  {
        let jsonString = await AIProxyIntegration.getColorPalette(forImage: image)
        let jsonData = jsonString!.data(using: .utf8)!

        do {
            sampleColors = try JSONDecoder().decode(Colors.self, from: jsonData)
        } catch {
            fatalError("Failed to decode JSON: \(error)")
        }
    }
}

#Preview {
    ContentView()
}

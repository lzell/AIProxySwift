//
//  ColorDetailView.swift
//  AIColorPalette
//
//  Created by Todd Hamilton on 6/22/24.
//

import SwiftUI

struct ColorDetailView: View {

    @Binding var currentColor:ColorData
    @State var copiedToClipboard:Bool = false
    @State private var hexValue:String = ""
    @State private var rgbValue:String = ""

    var body: some View {
        VStack(spacing:16){
            ZStack{
                Circle()
                    .fill(.white)
                    .frame(width:68)
                    .shadow(radius: 2, x: 0, y: 2)
                Circle()
                    .fill(Color(red:currentColor.red, green: currentColor.green, blue: currentColor.blue))
                    .frame(width:60)
            }
            .padding(.vertical, 16)

            HStack{
                Text(hexValue)
                    .fontWeight(.medium)
                Spacer()
                Button{
                    copyToClipboard(copyItem: hexValue)
                }label:{
                    Image(systemName: "square.on.square")
                }
                .buttonStyle(.bordered)
                .tint(Color(red:currentColor.red, green: currentColor.green, blue: currentColor.blue))
                .sensoryFeedback(.success, trigger: copiedToClipboard)
            }
            Divider()
            HStack{
                Text(rgbValue)
                    .fontWeight(.medium)
                Spacer()
                Button{
                    copyToClipboard(copyItem: rgbValue)
                }label:{
                    Image(systemName: "square.on.square")
                }
                .buttonStyle(.bordered)
                .tint(Color(red:currentColor.red, green: currentColor.green, blue: currentColor.blue))
                .sensoryFeedback(.success, trigger: copiedToClipboard)
            }
            Spacer()

        }
        .padding()
        .overlay(
            ZStack{
                if copiedToClipboard {
                    Text("Copied to clipboard")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.75).cornerRadius(20))
                        .padding(.bottom)
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        .frame(maxHeight:.infinity, alignment:.bottom)
                }
            }
        )
        .onAppear{
            hexValue = rgbToHex(red: currentColor.red, green: currentColor.green, blue: currentColor.blue)
            rgbValue = "rgb(\(String(format: "%.2f", currentColor.red)), \(String(format: "%.2f", currentColor.green)), \(String(format: "%.2f", currentColor.blue)))"
        }
    }


    func rgbToHex(red: CGFloat, green: CGFloat, blue: CGFloat) -> String {
        let r = Int(red * 255.0)
        let g = Int(green * 255.0)
        let b = Int(blue * 255.0)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    func copyToClipboard(copyItem: String) {
        UIPasteboard.general.string = copyItem
        withAnimation(.snappy){
            copiedToClipboard = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            withAnimation(.snappy){
                copiedToClipboard = false
            }
        }
    }

}

#Preview {
    ZStack{
        Image("palm")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width:UIScreen.main.bounds.width)
        ColorDetailView(currentColor: .constant(ColorData(red: 0.5, green:0.2, blue:0.3)))
            .background(.thickMaterial)
    }
}

//
//  Content.swift
//  demo
//
//  Created by shayanbo on 2023/1/4.
//

import SwiftUI
import Combine

let context = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)
let luts = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U"
]

struct Content : View {
    
    @State var image = UIImage(named: "IMG_2548")!
    @State var lut: String?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 500)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(luts, id: \.self) { lut in
                        Text("\(lut)")
                            .frame(width: 80, height: 100)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .font(Font.system(size: 50, weight: .thin))
                            .allowsHitTesting(true)
                            .onTapGesture {
                                self.lut = lut
                            }
                    }
                }
            }
            
        }
        .background(.black)
        .onChange(of: lut, perform: { newValue in
            
            guard let lut = newValue else { return }
            
            guard let original = CIImage(image: UIImage(named: "IMG_2548")!) else { return }
            
            guard let lutImagePath = Bundle.main.path(forResource: "lut.bundle/\(lut).png", ofType: nil) else { return }
            
            guard let lutImage = UIImage(contentsOfFile: lutImagePath) else { return }
            
            guard let filter = CICubeColorGenerator(image: lutImage)?.filter() else { return }
            
            filter.setValue(original, forKey: kCIInputImageKey)
            guard let outputImage = filter.outputImage else { return }
            guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
            image = UIImage(cgImage: cgImage)
        })
    }
}

//
//  Content.swift
//  demo
//
//  Created by shayanbo on 2023/1/4.
//

import SwiftUI
import Combine

let context = CIContext(mtlDevice: MTLCreateSystemDefaultDevice()!)
let luts = try! FileManager.default.contentsOfDirectory(atPath: "\(Bundle.main.bundlePath)/lut.bundle")

struct Content : View {
    
    @State var image: UIImage? = UIImage(named: "test")
    @State var lut: String?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Group {
                if let image = image {
                    Image(uiImage: image).resizable().scaledToFit()
                } else {
                    Text("Pick 1 filter below!")
                }
            }//.frame(width: 400, height: 400)
            
            Divider()
            
            List {
                 ForEach(luts, id: \.self) { i in
                     Text("\(i)").frame(width: 80, height: 100)
                        .font(.system(size: 20))
                        .backgroundStyle(.brown)
                        .onTapGesture {
                            lut = i
                        }
                }
            }
            
        }.onChange(of: lut, perform: { newValue in
            
            guard let lut = newValue else { return }
            
            guard let original = CIImage(image: UIImage(named: "test")!) else { return }
            
            guard let lutImagePath = Bundle.main.path(forResource: "lut.bundle/\(lut)", ofType: nil) else { return }
            
            guard let lutImage = UIImage(contentsOfFile: lutImagePath) else { return }
            
            guard let filter = CICubeColorGenerator(image: lutImage)?.filter() else { return }
            
            filter.setValue(original, forKey: kCIInputImageKey)
            guard let outputImage = filter.outputImage else { return }
            guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
            image = UIImage(cgImage: cgImage)
        })
    }
}

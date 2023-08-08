//
//  CardView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/28/23.
//

import SwiftUI
import Photos

struct CardView: View {
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    @State private var image: Image?
    let theme: Theme = .celadon
    let entry: PlantalogEntry
    var body: some View {
        GeometryReader { screen in
            VStack(alignment: .leading, spacing: 0) {
                // entry.photo
                if let image = image {
                    image
                        .resizable()
                        .frame(width: screen.size.width, height: 0.75 * screen.size.width, alignment: .top)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                } else {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: screen.size.width, height: 0.75 * screen.size.width, alignment: .top)
                            .aspectRatio(contentMode: .fill)
                        ProgressView()
                    }
                    
                }
                
                
                theme.mainColor
                    .frame(width: screen.size.width, height: 0.25 * screen.size.width, alignment: .top)
                    .aspectRatio(contentMode: .fill)
                    
                    .overlay(alignment: .center) {
                        VStack (spacing: 2){
                            Text(entry.species)
                                .fontWeight(.semibold)
                                .foregroundColor(theme.accentColor)
                                
                            HStack {
                                Label("\(entry.dateDiscovered.formatted(date: .numeric, time: .omitted))", systemImage: "calendar")
                                    .foregroundColor(theme.accentColor)
                            }
                        }

                    }
            }
            .task {
                if entry.photoID != nil {
                    await loadImageAsset()
                }
            }
            .onDisappear {
                image = nil
            }
        }
    }
}

extension CardView {
    func loadImageAsset(
        targetSize: CGSize = PHImageManagerMaximumSize
    ) async {
            guard let uiImage = try? await photoLibraryService
            .fetchImage(
                localID: self.entry.photoID!,
                targetSize: targetSize
            ) else {
                image = nil
                return
            }
        image = Image(uiImage: uiImage)
    }
}


struct CardView_Previews: PreviewProvider {
    static var entry = PlantalogEntry.sampleData[0]
    static var previews: some View {
        CardView(entry: entry)
            .previewLayout(.fixed(width: 300, height: 300))

    }
}

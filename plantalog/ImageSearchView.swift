//
//  ImageSearchView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 8/22/23.
//

import SwiftUI

struct ImageSearchView: View {
    @Binding var entry: PlantalogEntry
    @Binding var searchImage: UIImage?
    @Binding var capturedImage: Image?
    @Binding var isEditViewPresented: Bool
    @State var loading: Bool = true
    @State var isSearchResultsPresented: Bool = false
    @State var searchResult: WebResult? = nil
    var body: some View {
        NavigationStack {
            if let image = capturedImage {
                image
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        ProgressView()
                            .isPresenting(loading)
                            .foregroundColor(.white)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {}) {
                                NavigationLink(destination: DetailEditView(entry: $entry, capturedImage: $capturedImage, isEditViewPresented: $isEditViewPresented, isNewEntry: true, editedEntry: $entry.wrappedValue).navigationBarBackButtonHidden()
                                ) {
                                    Text("Continue")
                                        .foregroundColor(Theme.asparagus.mainColor)
                                }
                            }
                        }
                    }
            }
            
            
        }
        .sheet(isPresented: $isSearchResultsPresented) {
            SearchResultsView(searchResult: $searchResult)
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            if let searchImage = searchImage {
                VisionAPIWebDetection().detect(image: searchImage) { webResult in
                    loading = false
                    guard let webResult = webResult else {
                        fatalError("Web search failed")
                    }
                    searchResult = webResult
                    isSearchResultsPresented = true
                }
            } else {
                fatalError("No image provided for image search")
            }
            
        }
    }
}

struct SearchResultsView: View {
    @Binding var searchResult: WebResult?
    var body: some View {
        
        List {
            Section(header: Text("Search completed with \(searchResult!.annotations.count) results")) {
                ForEach(searchResult!.annotations, id: \.mid) { annotation in
                    Text("\(annotation.description)")
                }
            }
        }
        
        
    }
}

extension View {
    @ViewBuilder func isPresenting(_ isPresenting: Bool) -> some View {
        if isPresenting {
            self
        } else {
            self.hidden()
        }
    }
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSearchView(entry: .constant(PlantalogEntry.sampleData[0]), searchImage: .constant(UIImage(named: "tulip")), capturedImage: .constant(Image("tulip")), isEditViewPresented: .constant(true))
    }
}

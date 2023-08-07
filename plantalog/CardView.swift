//
//  CardView.swift
//  plantalog
//
//  Created by Marlene Grieskamp on 7/28/23.
//

import SwiftUI

struct CardView: View {
    let theme: Theme = .celadon
    let entry: PlantalogEntry
    var body: some View {
        GeometryReader { screen in
            VStack(alignment: .leading, spacing: 0) {
                // entry.photo
                Image("tulip")
                    .resizable()
                    .frame(width: screen.size.width, height: 0.75 * screen.size.width, alignment: .top)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
                
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
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var entry = PlantalogEntry.sampleData[0]
    static var previews: some View {
        CardView(entry: entry)
            .previewLayout(.fixed(width: 300, height: 300))

    }
}

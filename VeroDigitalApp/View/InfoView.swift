//
//  InfoView.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

struct InfoView: View {
    
    var title : String
    var subTitle : String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(title) :")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text("\(subTitle == "" ? title : subTitle)")
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(nil)
            
            Divider()
                .padding(.bottom, 20)
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

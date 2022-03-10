//
//  TextStackView.swift
//  Parkiling
//
//  Created by Nicholas on 10/03/22.
//

import SwiftUI


struct TextStackView: View {
    var title: String
    var desc: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(.caption, design: .rounded))
                .textCase(.uppercase)
                .foregroundColor(.secondary)
            Text(desc)
                .font(.system(.title3, design: .rounded))
        }
        .frame(maxWidth: .infinity)
    }
}

struct TextStackView_Previews: PreviewProvider {
    static var previews: some View {
        TextStackView(title: "Bahasa", desc: "Indonesia")
    }
}

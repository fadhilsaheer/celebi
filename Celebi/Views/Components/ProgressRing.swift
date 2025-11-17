//
//  ProgressRing.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//


import SwiftUI

struct ProgressRing: View {
    let progress: Double
    
    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(Color.blue, lineWidth: 4)
            .rotationEffect(.degrees(-90))
            .frame(width: 40, height: 40)
    }
}

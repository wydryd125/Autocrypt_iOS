//
//  SearchBar.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/11/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @FocusState private var isFocuse: Bool

    var body: some View {
        HStack {
            if searchText.isEmpty {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
        
            TextField("Search", text: $searchText)
                .focused($isFocuse)
                .padding(8)
                .cornerRadius(8)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    isSearching = true
                }
            
            if !searchText.isEmpty && isFocuse {
                Button(action: {
                    searchText.removeAll()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.midGrayBlue)
        .cornerRadius(10)
        .shadow(color: Color.midBlue.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

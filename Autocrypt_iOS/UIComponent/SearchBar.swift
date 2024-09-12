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
                .onTapGesture {
                    isSearching = true // 서치바 터치 시 키보드 올라옴
                }
            
            if !searchText.isEmpty && isFocuse {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.subTitleGrayBlue)
        .cornerRadius(10)
        .shadow(color: Color.contentsBlue.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}

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
                .frame(maxWidth: .infinity) // VStack의 너비를 확장하여 전체 영역을 터치 가능하게 함
                .contentShape(Rectangle()) // VStack 전체를 터치 가능한 영역으로 지정
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

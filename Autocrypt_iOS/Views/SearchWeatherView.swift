//
//  SearchWeatherView.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/10/24.
//

import SwiftUI
import RxSwift

struct SearchWeatherView: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var filteredCities = [City]()
    
    @ObservedObject var viewModel: CitySearchViewModel
    private let disposeBag = DisposeBag()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                searchBar
                searchListView
            }
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 16)
        .background(Color.deepBlue)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            viewModel.filterCitiesRelay
                .asObservable()
                .subscribe(onNext: { cities in
                    self.filteredCities = cities
                })
                .disposed(by: disposeBag)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    private var searchBar: some View {
        VStack {
            HStack {
                Button(action: {
                    searchText.removeAll()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16))
                        .foregroundColor(.midGrayBlue)
                        .padding(.trailing, 8)
                }
                
                SearchBar(searchText: $searchText, isSearching: .constant(true))
                    .focused($isFocused)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.searchQuery.accept(newValue)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                            isFocused = true
                        }
                    }
            }
        }
    }
    
    private var searchListView: some View {
        LazyVStack(spacing: 8) {
            ForEach(filteredCities) { city in
                VStack(spacing: 8) {
                    Text(city.name)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(city.country)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectCity.accept(city)
                    searchText.removeAll()
                    presentationMode.wrappedValue.dismiss()
                }
                
                Divider()
                    .background(Color.white)
                    .frame(height: 0.4)
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

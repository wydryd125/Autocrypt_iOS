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
    @FocusState private var isFocuse: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var filteredCities = [City]()
    
    private let viewModel = CitySearchViewModel()
    private let weatherViewModel = WeatherViewModel()
    //이거 수정wjd
    
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
        .background(Color.searchBlue)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            // View가 나타날 때 filterCitiesRelay를 구독합니다.
            viewModel.output.filterCitiesRelay
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
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16))
                        .foregroundColor(.subTitleGrayBlue)
                        .padding(.trailing, 8)
                }
                
                SearchBar(searchText: $searchText, isSearching: .constant(true))
                    .focused($isFocuse)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.input.searchQuery.accept(searchText.lowercased())
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                            isFocuse = true
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
                .frame(maxWidth: .infinity) // VStack의 너비를 확장하여 전체 영역을 터치 가능하게 함
                .contentShape(Rectangle()) // VStack 전체를 터치 가능한 영역으로 지정
                .onTapGesture {
                    print("서티 탭", city.name)
                    weatherViewModel.input.selectCity.accept(city)
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

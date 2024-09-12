//
//  MainWeatherView.swift.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/9/24.
//

import SwiftUI
import RxSwift
import MapKit

struct WeatherTempData: Identifiable {
    let id = UUID()
    let time: String
    let temperature: String
    let description: String
}

struct KeyPointsData: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let subDescription: String?
}

struct MainWeatherView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    
    @StateObject private var viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    
    let weatherData = [WeatherTempData(time: "오늘", temperature: "20°C", description: "Clear"),
                           WeatherTempData(time: "수", temperature: "22°C", description: "Sunny"),
                           WeatherTempData(time: "금", temperature: "24°C", description: "Partly Cloudy"),
                           WeatherTempData(time: "일", temperature: "26°C", description: "Sunny"),
                           WeatherTempData(time: "화", temperature: "25°C", description: "Partly Cloudy"),
                           WeatherTempData(time: "목", temperature: "22°C", description: "Clear")]
    
    let keyPointsData = [KeyPointsData(title: "습도", description: "56%", subDescription: nil),
                         KeyPointsData(title: "구름", description: "50%", subDescription: nil),
                         KeyPointsData(title: "바람 속도", description: "1.97m/s", subDescription: "강풍: 3.39m/s"),
                         KeyPointsData(title: "기압", description: "1030\nhpa", subDescription: nil)]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .background(Color.mainBlue)
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    if let weatherData = viewModel.weatherData,
                       let forecastData = viewModel.weatherForecastData {
                
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                searchBar
                                headerView(data: weatherData)
                                todayWeatherView(data: forecastData)
                                weekWeatherView(data: forecastData)
                                weatherLocationView(data: weatherData)
                                weatherKeyPointsView
                            }
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 16)
                        .background(Color.mainBlue)
                        .edgesIgnoringSafeArea(.bottom) // 하단 안전 영역을 무시하여 배경이 하단까지 차지하도록 설정
                    }
                }
            }
            .onAppear {
                setWeather()
            }
        }
    }
    
    private func setWeather() {
        viewModel.input.selectCity.accept(nil) // 기본적으로 서울 위치를 선택
    }
    
    private var searchBar: some View {
        SearchBar(searchText: $searchText, isSearching: $isSearching)
            .onTapGesture {
                isSearching = true
            }
            .navigationDestination(isPresented: $isSearching) {
                SearchWeatherView(searchText: $searchText) // 검색 화면으로 이동
                    .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
                    .navigationBarHidden(true)
            }
    }
    
    private func headerView(data: WeatherData) -> some View {
        VStack() {
            Spacer(minLength: 24)
            Text(data.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(data.base)
                .font(.system(size: 64))
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Text(data.name)
                .font(.title)
                .italic()
                .foregroundColor(.white)
            
//            Button(action: {
//                // Refresh action here
//            }) {
//                Text("Refresh")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
            .padding(.vertical, 24)
        }
    }
    
    private func todayWeatherView(data: WeatherForecastData) -> some View {
        VStack(spacing: 0) {
            Text("돌풍의 풍속은 최대 4m/s~~!!!")
                .font(.subheadline)
                .foregroundColor(Color.subTitleGrayBlue)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.contentsBlue)
            
            Divider()
                .background(Color.white)
                .frame(height: 0.4)
            
            // 콜렉션 뷰
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 4) {
                    ForEach(weatherData) { item in
                        VStack(spacing: 2) {
                            Text(item.time)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(height: 16)
                            
                            Image("sunny") // 로컬 이미지 사용
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48) // 이미지 크기 조절
                            
                            Text(item.temperature)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(height: 16)
                        }
                        .frame(width: 64, height: 84)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.contentsBlue) // 전체 배경색 설정
        .cornerRadius(10)
    }
    
    private func weekWeatherView(data: WeatherForecastData) -> some View {
        VStack(spacing: 0) {
            Text("5일간의 일기예보")
                .font(.subheadline)
                .foregroundColor(Color.subTitleGrayBlue)
                .padding(.vertical, 8) // 상하 패딩
                .frame(maxWidth: .infinity, alignment: .leading) // Leading 정렬
                .background(Color.contentsBlue)
            
            Divider()
                .background(Color.white)
                .frame(height: 0.4)
            
            GeometryReader { geometry in
                LazyVStack(spacing: 0) {
                    let geometryWidth = geometry.size.width - 24
                    ForEach(Array(weatherData.enumerated()), id: \.offset) { index, data in
                        HStack {
                            Text(data.time)
                                .font(.body)
                                .frame(width: geometryWidth * 0.3, alignment: .leading)
                                .foregroundColor(.white)
                            
                            Text(data.temperature)
                                .font(.headline)
                                .frame(width: geometryWidth * 0.2, alignment: .center)
                                .foregroundColor(.white)
                            
                            Text(data.description)
                                .font(.subheadline)
                                .frame(width: geometryWidth * 0.5, alignment: .trailing)
                                .foregroundColor(.white)
                        }
                        .frame(height: 40) // HStack 높이
                        
                        if index < weatherData.count - 1 {
                            Divider() // 각 셀 사이에 라인 추가
                                .background(Color.white)
                                .frame(height: 0.4) // 두께 0.4mm
                        }
                    }
                }
            }
            .frame(height: CGFloat(weatherData.count * 40))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.contentsBlue) // 전체 배경색 설정
        .cornerRadius(10)
    }
    
    func weatherLocationView(data: WeatherData) -> some View {
        VStack {
            VStack(spacing: 0) {
                Text("강수량")
                    .font(.subheadline)
                    .foregroundColor(Color.subTitleGrayBlue)
                    .padding(.vertical, 8) // 상하 패딩
                    .frame(maxWidth: .infinity, alignment: .leading) // Leading 정렬
                    .background(Color.contentsBlue)
    
                MapView(coordinate: CLLocationCoordinate2D(latitude: data.coord.lat,
                                                           longitude: data.coord.lon))
                    .frame(height: 300) // 맵의 높이 설정
                    .cornerRadius(8) // 모서리 둥글게
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.contentsBlue)
        .cornerRadius(10)
    }
    
    private var weatherKeyPointsView: some View {
        GeometryReader { geometry in
            let itemWidth = (geometry.size.width - 20) / 2
            
            LazyVGrid(columns: [GridItem(.fixed(itemWidth), spacing: 20),
                                GridItem(.fixed(itemWidth), spacing: 20)],
                      spacing: 16) {
                
                ForEach(keyPointsData) { item in
                    VStack {
                        Text(item.title)
                            .font(.subheadline)
                            .frame(width: itemWidth, alignment: .leading)
                            .padding(.leading, 16)
                            .foregroundColor(.white)
                        Spacer()
                        Text(item.description)
                            .font(.system(size: 32))
                            .frame(width: itemWidth, alignment: .leading)
                            .padding(.leading, 16)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .frame(width: itemWidth, height: itemWidth, alignment: .center)
                    .background(Color.contentsBlue)
                    .cornerRadius(10)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.width - 36) // `GeometryReader`의 높이 설정
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView()
    }
}

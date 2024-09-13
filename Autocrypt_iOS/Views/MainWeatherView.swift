//
//  MainWeatherView.swift.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/9/24.
//

import SwiftUI
import RxSwift
import MapKit

struct MainWeatherView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    
    @StateObject private var viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 화면을 차지하도록 설정
                        .background(Color.mainBlue) // 배경 색상 설정
                        .edgesIgnoringSafeArea(.all)
                } else {
                    if let forecastData = viewModel.weatherForecastData,
                       let weatherData = viewModel.weatherData {
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                searchBar
                                headerView(curDate: weatherData, data: forecastData)
                                todayWeatherView(data: forecastData)
                                weekWeatherView(data: forecastData)
                                weatherLocationView(data: weatherData)
                                weatherKeyPointsView(data: forecastData)
                            }
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 16)
                        .background(Color.mainBlue)
                        .edgesIgnoringSafeArea(.bottom) // 하단 안전 영역을 무시하여 배경이 하단까지 차지하도록 설정
                    }
                }
            }
        }
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
    
    private func headerView(curDate: WeatherData, data: WeatherForecastData) -> some View {
        VStack() {
            Spacer(minLength: 32)
            Text(data.getCityName())
                .font(.system(size: 40))
                .foregroundColor(.white)
            
            Spacer(minLength: 24)
            Text(curDate.main.temp.getTemperatureString())
                .font(.system(size: 64))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            Text(curDate.getCurWeather())
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Spacer()
            Text(data.getMinMaxTemperature())
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.bottom, 8)
        }
    }
    
    private func todayWeatherView(data: WeatherForecastData) -> some View {
        VStack(spacing: 0) {
            Text("돌풍의 풍속은 최대 " + data.getWindMaxSpeed() + " 입니다.")
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
                    ForEach(data.getDateWeatherList()) { item in
                        VStack(spacing: 2) {
                            Text(item.date.fullDate().formattedTime())
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(height: 16)
                            
                            let weather = item.weather[0]
                            Image(weather.getWeatherImage(id: weather.id))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48) // 이미지 크기 조절
                            
                            Text(item.main.temp.getTemperatureString())
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
        return VStack(spacing: 0) {
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
                    let weatherList = data.getWeekWeatherList()
                    let geometryWidth = geometry.size.width - 24
                    
                    ForEach(weatherList.indices, id: \.self) { idx in
                        let data = weatherList[idx]
                        
                        HStack {
                            Text(data.dayOfWeek)
                                .font(.body)
                                .frame(width: geometryWidth * 0.3, alignment: .leading)
                                .foregroundColor(.white)
                            
                            Text(data.temp.getTemperatureString())
                                .font(.headline)
                                .frame(width: geometryWidth * 0.2, alignment: .center)
                                .foregroundColor(.white)
                            
                            Text(data.getMinMaxTemperature())
                                .font(.subheadline)
                                .frame(width: geometryWidth * 0.5, alignment: .trailing)
                                .foregroundColor(.white)
                        }
                        .frame(height: 40)
                        
                        if idx < weatherList.count - 2 {
                            Divider() // 각 셀 사이에 라인 추가
                                .background(Color.white)
                                .frame(height: 0.4) // 두께 0.4mm
                        }
                    }
                }
            }
            .frame(height: CGFloat(40 * 5))
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
    
    private func weatherKeyPointsView(data: WeatherForecastData) -> some View {
        GeometryReader { geometry in
            let itemWidth = (geometry.size.width - 20) / 2
            
            LazyVGrid(columns: [GridItem(.fixed(itemWidth), spacing: 20),
                                GridItem(.fixed(itemWidth), spacing: 20)],
                      spacing: 16) {
                
                ForEach(data.getKeyPointsData()) { item in
                    VStack {
                        Text(item.title)
                            .font(.subheadline)
                            .frame(width: itemWidth, alignment: .leading)
                            .padding(.leading, 16)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(item.description)
                            .font(.system(size: 32))
                            .frame(width: itemWidth, alignment: .leading) // 수평 정렬은 leading
                            .padding(.leading, 16)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if let sub = item.subDescription {
                            Text(sub)
                                .font(.subheadline)
                                .frame(width: itemWidth, alignment: .leading)
                                .padding(.leading, 16)
                                .foregroundColor(.white)
                        }
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

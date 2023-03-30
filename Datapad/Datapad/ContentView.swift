//
//  ContentView.swift
//  Datapad
//
//  Created by Sree Gajula on 3/28/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var planetName = "Loading..."
    @State var planetDescription = "Loading..."
    @State var planetImageURL = ""
    
    @State var temperature = 0
    @State var weatherDesc = "Loading..."
    
    @State var searchText = "Corvallis"
    
    @State var mainURL = "http://18.237.253.141:5000/planet/location/"
    
    
    
    
    
    var body: some View {
        ZStack {
            if planetImageURL.isEmpty {
                Color.white
            } else {
                AsyncImage(url: URL(string: planetImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .overlay(Color.black.opacity(0.2))
                } placeholder: {
                    Color.white
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
            
            
            VStack {
                HStack {
                    TextField("", text: $searchText, onEditingChanged: { began in
                        if !began {
                            print(searchText)
                            fetchPlanet()
                            fetchForecast()
                        }
                    })
                        .onReceive(Just(searchText)) { newValue in
                                fetchPlanet()
                                fetchForecast()
                            }
                        .foregroundColor(.white)
                        .placeholder(when: searchText.isEmpty) {
                            Text("Location").foregroundColor(.white)
                        }
                    Image(systemName: "location")
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                }.frame(maxWidth: 270)
                Spacer()
 
                
                Text("\(temperature)°" + ", " + weatherDesc.capitalized)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 500)
                                
                Text(planetName)
                    .font(.system(size: 65, weight: .bold))
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 500)
                
                Text(planetName)
                    .font(.custom("Aurebesh", size: 25))
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 500)
                
                        
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            fetchPlanet()
            fetchForecast()
        }
    }
    
    func fetchPlanet() {
        guard let url = URL(string: "http://18.237.253.141:5000/planet/location/" + searchText + "/") else {
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let planetData = try decoder.decode(PlanetData.self, from: data)
                    DispatchQueue.main.async {
                        self.planetName = planetData.data.name
                        self.planetDescription = planetData.data.description
                        self.planetImageURL = planetData.data.imageURL
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func fetchForecast() {
        guard let url = URL(string: "http://18.237.253.141:5000/planet/location/" + searchText + "/forecast") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let forecast = try decoder.decode(Forecast.self, from: data)
                    DispatchQueue.main.async {
                        let temperatureString = Int(forecast.temperature)
                        self.temperature = temperatureString
                        self.weatherDesc = forecast.description
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder()
                .opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

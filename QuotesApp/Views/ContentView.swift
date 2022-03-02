


import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    @State var currentQuote: Quote = Quote(quoteText: "Press for Quote",
                                           quoteAuthor: "",
                                           senderName: "",
                                           senderLink: "",
                                           quoteLink: "" )
                                            
                                       
    @State var favourites: [Quote] = []
    
    @State var currentQuoteAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        VStack {
            
            Text(currentQuote.quoteText)
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(20)
                .minimumScaleFactor(1)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primary, lineWidth: 5)
                )
                .padding(10)
            
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
                .onTapGesture {
                    if currentQuoteAddedToFavourites == false {
                    favourites.append(currentQuote)
                    
                    currentQuoteAddedToFavourites = true
                    }
                }
            
            Button(action: {
                print("I've been pressed.")
                
             
                
                Task {
                    await loadNewQuote()
                }
                
                
                }, label: {
                    
                Text("Press for another one!")
            })
                .buttonStyle(.bordered)
            
            HStack {
                Text("Favourite quotes")
                    .bold()
                
                Spacer()
            }
           
            List(favourites, id: \.self) { currentQuote in
                Text(currentQuote.quoteText)
            }
            
            Spacer()
                        
        }
        .task {
            
            await loadNewQuote()
            
            print("Tried to load a new quote")
        }
        .navigationTitle("GoodQuotes")
        .padding()
    }
    
    //MARK: Functions
  
    func loadNewQuote() async  {
     
        let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&key=457653&format=json&lang=en")!
        
        
        var request = URLRequest(url: url)
      
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        let urlSession = URLSession.shared
        
        
        do {
            
      
            let (data, _) = try await urlSession.data(for: request)
            
            currentQuote = try JSONDecoder().decode(Quote.self, from: data)
            currentQuoteAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
           
            print(error)
        }

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}

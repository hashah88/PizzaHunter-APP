
import Foundation
import Siesta


// contains the code that will be needed to make an API request.
class YelpAPI {
  
  // This creates a singleton ( only one instance of ) YelpAPI. Lazily initialized.
   // only the NetworkManager class can create instances of itself.
  static let sharedInstance = YelpAPI()
  
  private let service = Service(baseURL: "https://api.yelp.com/v3", standardTransformers: [.text, .image])
  private init(){
    LogCategory.enabled = [.network, .pipeline, .observers]
    service.configure("**"){
      
      $0.headers["Authorization"] =
      "Bearer B6sOjKGis75zALWPa7d2dNiNzIefNbLGGoF75oANINOL80AUhB1DjzmaNzbpzF-b55X-nG2RUgSylwcr_UYZdAQNvimDsFqkkhmvzk6P8Qj0yXOQXmMWgTD_G7ksWnYx"
      $0.expirationTime = 60 * 60 // 60s * 60m = 1 hour

    }
    
    
    // This snippet of code mainly transforms the Resource into a [Restaurant]. (Modifies it)
    // Explanation : the transformer will take any Resource that hits the endpoint "/business/search"
    // and then it will pass the responseJson to the SearchResuls's initiliazer.
    // In short the Resource object will change from raw json to [Restaurant]
    let jsonDecoder = JSONDecoder()
    
    service.configureTransformer("/businesses/*") {
      try jsonDecoder.decode(RestaurantDetails.self, from: $0.content)
    }

    service.configureTransformer("/businesses/search") {
      try jsonDecoder.decode(SearchResults<Restaurant>.self, from: $0.content).businesses
    }
  }
  
  
  
  // This function is the one that gets the actual data. Here, "Resource" is the response object.
  func restaurantList(for location: String) -> Resource {
    return service
      .resource("/businesses/search")
      .withParam("term", "pizza")
      .withParam("location", location)
  }
  
  func restaurantDetails(_ id: String) -> Resource {
    return service
      .resource("/businesses")
      .child(id)
  }


  
}

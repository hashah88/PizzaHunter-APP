

import Foundation

// More Info: https://www.raywenderlich.com/382-encoding-decoding-and-serialization-in-swift-4
// Here, we are giving  struct "restaurant" ability to get encoded or decoded.
struct Restaurant : Codable {
  let id: String
  let name: String
  let imageUrl: String
  
  // We are basically renaming the keys here so that while encoding or decoding the data, if the key names differ
  // then it will look at this and will not create any conflicts.
  enum CodingKeys : String, CodingKey {
    case id
    case name
    case imageUrl = "image_url"
  }
}

struct SearchResults < T : Decodable> : Decodable {
  let businesses : [T]
}




import Foundation

struct HMKMapItemsResponseModel {
    let results: [HMKMapItemResponseModel]
}

struct HMKMapItemsResponseBuilder {
    let results: [HMKMapItemResponseBuilder]?
    
    init(array: [[String: Any]]) {
        results = array.compactMap { HMKMapItemResponseBuilder(dictionary: $0) }
    }
    
    func build() -> HMKMapItemsResponseModel? {
        return HMKMapItemsResponseModel(results: results?.compactMap { $0.build() } ?? [])
    }
}

struct HMKMapItemResponseBuilder {
    
    let name: String?
    let lat: Double?
    let lng: Double?
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        if let geocode = dictionary["geocode"] as? [String : Any], let location = geocode["location"] as? [String : Any] {
            lat = location["lat"] as? Double
            lng = location["lng"] as? Double
        } else {
            lat = 0.0
            lng = 0.0
        }
    }
    
    func build() -> HMKMapItemResponseModel? {
        guard let name = name, let lat = lat, let lng = lng else { return nil }

        return HMKMapItemResponseModel(name: name, lat: lat, lng: lng)
    }
}

struct HMKMapItemResponseModel {
    let name: String!
    let lat: Double!
    let lng: Double!
}

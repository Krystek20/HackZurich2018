import Foundation

struct HMKMyListItemsResponseModel {
    let results: [HMKMyListItemResponseModel]
}

struct HMKMyListItemsResponseBuilder {
    let results: [HMKMyListItemResponseBuilder]?
    
    init(array: [[String: Any]]) {
        results = array.compactMap { HMKMyListItemResponseBuilder(dictionary: $0) }
    }
    
    func build() -> HMKMyListItemsResponseModel? {
        return HMKMyListItemsResponseModel(results: results?.compactMap { $0.build() } ?? [])
    }
}

struct HMKMyListItemResponseBuilder {
    
    let tabsNumber: Int?
    let swissId: Int?
    let packType: String?
    let name: String?
    let isEmpty: Bool?
    
    init(dictionary: [String: Any]) {
        tabsNumber = dictionary["tabs_number"] as? Int
        swissId = dictionary["swiss_id"] as? Int
        packType = dictionary["pack_type"] as? String
        name = dictionary["name"] as? String
        isEmpty = (tabsNumber ?? 0) == 0
    }
    
    func build() -> HMKMyListItemResponseModel? {
        guard let tabsNumber = tabsNumber, let swissId = swissId, let packType = packType, let name = name else { return nil }
        
        return HMKMyListItemResponseModel(tabsNumber: tabsNumber, swissId: swissId, packType: packType, name:name, isEmpty: isEmpty)
    }
}

struct HMKMyListItemResponseModel {
    let tabsNumber: Int!
    let swissId: Int!
    let packType: String!
    let name: String!
    var isEmpty: Bool!
}

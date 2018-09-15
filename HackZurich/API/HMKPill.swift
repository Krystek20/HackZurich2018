import Foundation

struct HMKPillsResponseModel {
    let results: [HMKPillResponseModel]
}

struct HMKPillsResponseBuilder {
    let results: [HMKPillResponseBuilder]?
    
    init(array: [[String: Any]]) {
        results = array.compactMap { HMKPillResponseBuilder(dictionary: $0) }
    }
    
    func build() -> HMKPillsResponseModel? {
        return HMKPillsResponseModel(results: results?.compactMap { $0.build() } ?? [])
    }
}

struct HMKPillResponseBuilder {
    
    let swissMedicId: String?
    let title: String?
    let authHolder: String?
    
    init(dictionary: [String: Any]) {
        swissMedicId = (dictionary["swissmedicIds"] as? [String] ?? []).first
        title = dictionary["title"] as? String
        authHolder = dictionary["authHolder"] as? String
    }
    
    func build() -> HMKPillResponseModel? {
        guard let swissMedicId = swissMedicId, let title = title, let authHolder = authHolder else { return nil }
        
        return HMKPillResponseModel(swissMedicId: swissMedicId, title: title, authHolder: authHolder)
    }
}

struct HMKPillResponseModel {
    let swissMedicId: String!
    let title: String!
    let authHolder: String!
}


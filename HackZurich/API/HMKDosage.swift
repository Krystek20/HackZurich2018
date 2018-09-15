import Foundation

struct HMKDosagesResponseModel {
    let results: [HMKDosageResponseModel]
}

struct HMKDosagesResponseBuilder {
    let results: [HMKDosageResponseBuilder]?
    
    init(array: [[String: Any]]) {
        results = array.compactMap { HMKDosageResponseBuilder(dictionary: $0) }
    }
    
    func build() -> HMKDosagesResponseModel? {
        return HMKDosagesResponseModel(results: results?.compactMap { $0.build() } ?? [])
    }
}

struct HMKDosageResponseBuilder {
    
    let type: String?
    let dosage: String?
    let tabsNumber: Int?
    
    init(dictionary: [String: Any]) {
        type = dictionary["type"] as? String
        dosage = dictionary["dosage"] as? String
        tabsNumber = dictionary["tabs_number"] as? Int
    }
    
    func build() -> HMKDosageResponseModel? {
        guard let type = type, let dosage = dosage, let tabsNumber = tabsNumber else { return nil }
        
        return HMKDosageResponseModel(type: type, dosage: dosage, tabsNumber: tabsNumber)
    }
}

struct HMKDosageResponseModel {
    let type: String!
    let dosage: String!
    let tabsNumber: Int!
}

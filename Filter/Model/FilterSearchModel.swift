//
//  FilterSearchModel.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2023/01/19.
//  Copyright © 2023 GlobalYeoboya. All rights reserved.
//

import Foundation


struct FilterSearchModel: Equatable {
    static func == (lhs: FilterSearchModel, rhs: FilterSearchModel) -> Bool {
        return lhs.searchMarriageType == rhs.searchMarriageType &&
        lhs.searchGender == rhs.searchGender &&
        lhs.searchMinAge == rhs.searchMinAge &&
        lhs.searchMaxAge == rhs.searchMaxAge &&
        lhs.srchLocLCodeList == rhs.srchLocLCodeList &&
//        lhs.memLatitude == rhs.memLatitude &&
//        lhs.memLongitude == rhs.memLongitude &&
        lhs.srchMinDistance == rhs.srchMinDistance &&
        lhs.srchMaxDistance == rhs.srchMaxDistance
    }
    
    var searchMarriageType : Set<MarriageType>
    var searchGender       : Set<Gender>
    var searchMinAge       : Int
    var searchMaxAge       : Int
    
    /// ******************************************
    /// LocationFilter
    /// ******************************************
    var srchLocLCodeList   : Set<CountryCode>
    var memLatitude        : Double?
    var memLongitude       : Double?
    var srchMinDistance    : Int?
    var srchMaxDistance    : Int?
    
    public init(searchMarriageType: Set<MarriageType>,
                searchGender: Set<Gender>,
                searchMinAge: Int,
                searchMaxAge: Int,
                srchLocLCodeList: Set<CountryCode> = [],
                memLatitude: Double? = nil,
                memLongitue: Double? = nil,
                srchMinDistance: Int? = nil,
                srchMaxDistance: Int? = nil
    ) {
        self.searchMarriageType = searchMarriageType
        self.searchGender       = searchGender
        self.searchMinAge       = searchMinAge
        self.searchMaxAge       = searchMaxAge
        
        self.srchLocLCodeList   = srchLocLCodeList
        self.memLatitude        = memLatitude
        self.memLongitude       = memLongitue
        self.srchMinDistance    = srchMinDistance
        self.srchMaxDistance    = srchMaxDistance
    }
}


struct CountryCode: Codable, Hashable {
    var code : String
    var flagURL : String
    var name : String
    var continent: String
}

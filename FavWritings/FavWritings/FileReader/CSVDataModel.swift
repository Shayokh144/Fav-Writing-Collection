//
//  CSVDataModel.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 8/5/24.
//

import Foundation

struct CSVDataModel {
    
    let rows: [[String : String]]
    let columns: [String]?
    
    init(rows: [[String : String]], columns: [String]?) {
        self.rows = rows
        self.columns = columns
    }
}

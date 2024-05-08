//
//  FileReader.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 8/5/24.
//

import SwiftCSV
import Foundation

struct FileReader {
    
    func readCSVFile(fileName: String) -> (CSVDataModel?, String?) {
        return readCSVData(fileName: fileName)
    }
    
    private func readCSVData(fileName: String) -> (CSVDataModel?, String?) {
        guard let filePath = getFilePath(fileName: fileName, fileType: "csv") else {
            return (nil, "No CSV file found named: \(fileName)")
        }
        do {
            let csvFile: CSV = try CSV<Named>(url: URL(fileURLWithPath: filePath))
            var columns: [String]?
            if let keys = csvFile.columns?.keys {
                columns = Array(keys)
            }
            return (CSVDataModel(rows: csvFile.rows, columns: columns), nil)
        } catch {
            NSLog("ERROR: \(error)")
            return (nil, "No data found for file named: \(fileName)")
        }
    }
    
    private func getFilePath(fileName: String, fileType: String) -> String? {
        guard let filePath = Bundle.main.path(
            forResource: fileName,
            ofType: fileType
        ) else {
            NSLog("no such file")
            return nil
        }
        return filePath
    }
}

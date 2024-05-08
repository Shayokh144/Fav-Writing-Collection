//
//  HomeViewModel.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 8/5/24.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published private(set) var uiModel: [WritingDetailsUIModel]
    @Published private(set) var errorMessage: String
    
    private let fileReader: FileReader
    
    init(fileReader: FileReader = FileReader()) {
        self.fileReader = fileReader
        uiModel = []
        errorMessage = ""
        fetchCSVData()
    }
    
    private func fetchCSVData() {
        let (data, error) = fileReader.readCSVFile(fileName: "JibananandaDasPoem")
        guard error == nil else {
            errorMessage = error ?? ""
            return
        }
        if let data {
            processCSVFile(data: data)
        } else {
            errorMessage = "No data found"
        }
    }
    
    private func processCSVFile(data: CSVDataModel) {
        uiModel = []
        for row in data.rows {
            if let name = row["poemName"], let content = row["poemContent"] {
                let charactersToRemove = CharacterSet(charactersIn: "\(name)")
                let dataModel = WritingDetailsUIModel(
                    contentName: name,
                    // Removing duplicate name
                    content: content.trimmingCharacters(in: charactersToRemove),
                    writerName: row["writerName"] ?? "",
                    language: row["language"] ?? ""
                )
                uiModel.append(dataModel)
            }
        }
    }
}

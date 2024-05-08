//
//  HomeViewModel.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 8/5/24.
//

import Combine

final class HomeViewModel: ObservableObject {
    
    @Published private(set) var names: [String]
    @Published private(set) var errorMessage: String
    
    private let fileReader: FileReader
    private var CSVFileData: CSVDataModel?
    
    init(fileReader: FileReader = FileReader()) {
        self.fileReader = fileReader
        CSVFileData = nil
        names = []
        errorMessage = ""
        fetchCSVData()
    }
    
    func onTapName(index: Int) {
        
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
        CSVFileData = data
        names = []
        for row in data.rows {
            if let value = row["poemName"] {
                names.append(value)
            }
        }
    }
}

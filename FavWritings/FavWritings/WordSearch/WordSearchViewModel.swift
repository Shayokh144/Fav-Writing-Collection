//
//  WordSearchViewModel.swift
//  FavWritings
//
//  Created by Taher's nimble macbook on 13/5/24.
//

import Combine
import Foundation

final class WordSearchViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var maxWordCount: String = ""
    @Published var selectedLengthType: LengthFilterType = .equal
    @Published private(set) var wordList: [String]
    @Published private(set) var suffixMatchWords: [String]
    @Published private(set) var prefixMatchWords: [String]
    @Published private(set) var state: State
    @Published private(set) var selectedWord: String = ""
    
    private var suffixMatchWordList: [String]
    private var prefixMatchWordList: [String]
    private var cancellables = Set<AnyCancellable>()
    
    var lengthFilters: [String] {
        LengthFilterType.allCases.map { $0.rawValue }
    }
    
    var wordMeaningURL: URL? {
        URL(string: "https://www.google.com/search?q=\(selectedWord)+সমার্থক&oq=\(selectedWord)+সমার্থক")
    }
    
    init() {
        wordList = []
        suffixMatchWords = []
        prefixMatchWords = []
        suffixMatchWordList = []
        prefixMatchWordList = []
        state = .loaded
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.search(text: text)
                    self?.filterResult()
                }
            }
            .store(in: &cancellables)
        $maxWordCount
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filterResult()
            }
            .store(in: &cancellables)
    }
    
    func viewAppear() {
        if wordList.isEmpty {
            loadWordList()
        }
    }
    
    func updateLengthSelectionType(for newValue: String) {
        selectedLengthType = LengthFilterType(rawValue: newValue)
        filterResult()
    }
    
    private func filterResult() {
        guard let number = Int(maxWordCount) else {
            return
        }
        let lengthComparisonClosure: (String) -> Bool = {
            switch self.selectedLengthType {
                case .equal:
                    return $0.count == number
                case .greaterThanOrEqual:
                    return $0.count >= number
                case .lessThanOrEqual:
                    return $0.count <= number
            }
        }
        self.prefixMatchWords = self.prefixMatchWordList.filter(lengthComparisonClosure)
        self.suffixMatchWords = self.suffixMatchWordList.filter(lengthComparisonClosure)
    }
    
    private func search(text: String) {
        state = .loading
        prefixMatchWords.removeAll()
        suffixMatchWords.removeAll()
        suffixMatchWordList.removeAll()
        prefixMatchWordList.removeAll()
        var prefixWordDict: [String : Bool] = [:]
        var suffixWordDict: [String : Bool] = [:]
        for word in wordList {
            if word.hasPrefix(text) && prefixWordDict[word] == nil {
                prefixMatchWordList.append(word)
                prefixWordDict[word] = true
            }
            if word.hasSuffix(text) && suffixWordDict[word] == nil {
                suffixMatchWordList.append(word)
                suffixWordDict[word] = true
            }
        }
        prefixMatchWords = prefixMatchWordList
        suffixMatchWords = suffixMatchWordList
        state = .loaded
    }
    
    func tryAgain() {
        state = .loaded
        searchText = ""
    }
    
    func onSelectWord(word: String) {
        selectedWord = word
    }
    
    private func loadWordList() {
        state = .loading
        guard let filePath = Bundle.main.path(forResource: "BengaliSortedWords", ofType: "txt") else {
            NSLog("File not found.")
            state = .error
            return
        }
        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            wordList = fileContents.components(separatedBy: "\n")
            NSLog("Number of words found: \(wordList.count)")
            state = .loaded
        } catch {
            NSLog("Error reading file:", error.localizedDescription)
            state = .error
        }
    }
}

extension WordSearchViewModel {
    
    enum State {
        
        case loading
        case loaded
        case error
    }
    
    enum LengthFilterType: String, CaseIterable {
        
        case equal = "=  "
        case greaterThanOrEqual = ">=  "
        case lessThanOrEqual = "<=  "
        
        init(rawValue: String) {
            switch rawValue {
                case LengthFilterType.equal.rawValue:
                    self = .equal
                case LengthFilterType.greaterThanOrEqual.rawValue:
                    self = .greaterThanOrEqual
                default:
                    self = .lessThanOrEqual
            }
        }
    }
}


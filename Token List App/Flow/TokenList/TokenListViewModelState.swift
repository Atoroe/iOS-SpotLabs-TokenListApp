//
//  TokenListViewModelState.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

struct TokenListViewModelState {
    var sections: [Section]
    
    struct Section {
        var id: SectionID
        var items: [ItemID]
        
        init(id: SectionID, items: [ItemID] = []) {
            self.id = id
            self.items = items
        }
    }
    
    enum SectionID: CaseIterable {
        case main
    }
    
    enum ItemID {
        case token(context: Token)
    }
}

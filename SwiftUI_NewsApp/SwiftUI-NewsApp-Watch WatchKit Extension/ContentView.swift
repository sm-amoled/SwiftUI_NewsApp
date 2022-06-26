//
//  ContentView.swift
//  SwiftUI-NewsApp-Watch WatchKit Extension
//
//  Created by Park Sungmin on 2022/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMenuItemId: MenuItem.ID?
    @EnvironmentObject var searchVM: ArticleSearchViewModel
    
    var body: some View {
        
        ZStack{
            navigationLinkForMenuItem(MenuItem.search) {
                EmptyView()
            }
            .hidden()
            
            List {
                Section {
                    navigationLinkForMenuItem(.saved) {
                        Label(MenuItem.saved.text, systemImage: MenuItem.saved.systemImage)
                    }
                }
                
                Section {
                    ForEach(Category.menuItems) { item in
                        navigationLinkForMenuItem(item) {
                            listRowForCategoryMenuItem(item)
                        }
                    }
                } header: {
                    Text("Categories")
                }
            }
            .searchable(text: $searchVM.searchQuery)
            .onSubmit(of: .search, search)
            .navigationTitle("My News App")
        }
    }
    
    @ViewBuilder
    private func viewForMenuItem(_ item: MenuItem) -> some View {
        switch item {
        case .saved:
            BookmarkTabView()
        case .search:
            SearchTabView()
                .onDisappear {
                    searchVM.searchQuery = ""
                }
        case .category(let category):
            NewsTabView(category: category)
        }
    }
    
    // NavigationLink를 그려내는 함수
    // 두 번째 인자로 @ViewBuilder 클로저를 전달해주기 위해 프로토콜을 달아준다.
    // 위에서 사용할 때는 nav~~MenuItem(item, label: ) 또는 nav(item) { } 의 형태로 사용된다.
    private func navigationLinkForMenuItem<Label: View>(_ item: MenuItem, @ViewBuilder label:  () -> Label) -> some View {
        
        // NavigationLink에 붙은 tag와 selection
        // -> 동일한 selection에 대해 어떤 tag를 실행할 지를 결정하게 됨
        // 대충 isActive는 하나인데, 링크가 여러개라면 지정한 tag에 해당하는 링크를 호출한다.
        
        NavigationLink(
            destination: viewForMenuItem(item),
            tag: item.id,
            selection: $selectedMenuItemId) {
                // label 파트에 인자로 전달받은 클로저 label()을 넣어준다.
                // 아마도, label을 이 함수에 넣으면 자동으로 네비게이션 링크로 만들어주는 함수라고 생각된다.
                label()
            }
            .listItemTint(item.listItemTintColor)
        
    }
    
    @ViewBuilder
    private func listRowForCategoryMenuItem(_ item: MenuItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: item.systemImage)
                .imageScale(.large)
            Text(item.text)
        }
        .padding(.vertical, 10)
    }
    
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchQuery.isEmpty {
            return
        }
        
        selectedMenuItemId = MenuItem.search.id
        Task {
            await searchVM.searchArticle()
        }
    }
}

// fileprivate extension : 파일 내에서만 접근 가능한 영역 설정
fileprivate extension MenuItem {
    var listItemTintColor: Color? {
        switch self {
        case .category(let category):
            switch category {
            case .general:
                return .orange
            case .business:
                return  .blue
            case .entertainment:
                return .cyan
            case .health:
                return .indigo
            case .science:
                return .red
            case .sports:
                return .brown
            case .technology:
                return .purple
            }
            
            
        default:
            return nil
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ArticleSearchViewModel.shared)
            .environmentObject(ArticleBookmarkViewModel.shared)
    }
}

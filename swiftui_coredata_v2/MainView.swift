//
//  ContentView.swift
//  swiftui_coredata_v2
//
//  Created by pioner on 22.03.2021.
//

import SwiftUI

struct MainView: View {
    
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: ListTask.entity(), sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)] ) var lists: FetchedResults<ListTask>
    
    @State var edditingList = false
    
    @State var showMeny = false
    
    @State var isShowAlerAddEditList = false
    @State var listTitle: String = ""
    @State var isAddNewList: Bool?
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMeny = false
                    }
                }
            }
        
        return GeometryReader { geometry in
            NavigationView{
                ZStack(alignment: .leading) {
                    VStack {
                        if let currentList = getListActiveFromDB() {
                            List{
                                ForEach(currentList.taskArray) { task in
                                    Cell(task: task)
                                }
                                .onDelete(perform: removeTask)
                                .onMove(perform: moveTask)
                                .onLongPressGesture {
                                    withAnimation {
                                        self.edditingList.toggle()
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .environment(\.editMode, edditingList ? .constant(EditMode.active) : .constant(EditMode.inactive))
                        }
                        
                        if let _ = getListActiveFromDB() {
                            FormAdditingTask(listActive: getListActiveFromDB())
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.showMeny ? geometry.size.width/2 : 0)
                    .disabled(self.showMeny)
                    
                    if self.showMeny {
                        SidebarView(lists: lists, isShowingEditField: $isShowAlerAddEditList,listActive: getListActiveFromDB(), isAddNewList: $isAddNewList, listTitle: $listTitle)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                            .gesture(drag)
                    }
                }
                
                .navigationBarTitle(getListActiveFromDB()?.wrapedTitle ?? "", displayMode: .inline)
                .navigationBarItems(leading: (
                    Button(action: {
                        withAnimation {
                            self.showMeny.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                    }
                ))
            }
            
            AlertAddEditList(isShow: $isShowAlerAddEditList, listTitle: $listTitle, geometry: geometry) { listTitle in
                addOrEditList(&listTitle)
                
            }
        }
    }
    
    func addOrEditList(_ listTitle: inout String) {
        guard let isAdd = self.isAddNewList else {return}
        
        if isAdd {
            addNewList(listTitle)
        } else {
            editList(listTitle)
        }
        listTitle = ""
    }
    
    func addNewList(_ newName: String) {
        guard newName != "" else {return}
        
        let list = ListTask(context: moc)
        list.title = newName
        list.selected = false
        
        
        try? self.moc.save()
    }
    
    func editList(_ title: String) {
        guard title != "" else {return}
        guard let list = getListActiveFromDB() else {return}
        
        list.title = title
        saveContext()
    }
    
    func removeTask(at offsets: IndexSet) {
        guard let list = getListActiveFromDB() else {return}
        
        for index in offsets {
            let task = list.taskArray[index]
            moc.delete(task)
        }
        
        saveContext()
    }
    
    func moveTask(from source: IndexSet, to destination: Int){
        guard let list = getListActiveFromDB() else {return}
        let tasks = list.taskArray
        
        var sourceInt: Int = 0
        let _ = source.map {
            let t = tasks[$0]
            sourceInt = tasks.firstIndex {$0 === t}!
        }
        
        if sourceInt < destination {
            let dest1 = destination - 1
            tasks[sourceInt].number = tasks[dest1].number
            for i in sourceInt...dest1 {
                if i != sourceInt {
                    tasks[i].number -= 1
                }
            }
        } else {
            tasks[sourceInt].number = tasks[destination].number
            for i in destination...sourceInt {
                if i != sourceInt {
                    tasks[i].number += 1
                }
            }
        }
        
        withAnimation{
            edditingList = false
        }
        
        saveContext()
    }
    
    func getListActiveFromDB() -> ListTask? {
        
        for listItem in lists {
            if listItem.selected {
                return listItem
            }
        }
        return nil
    }
    
    func saveContext(){
        do {
            try self.moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}

//
//  MenuView.swift
//  checklist_coredata
//
//  Created by pioner on 20.01.2021.
//

import SwiftUI

struct SidebarView: View {
    
    @Environment(\.managedObjectContext) var moc
    let lists: FetchedResults<ListTask>
    
    @Binding var isShowingEditField: Bool
    @State private var orientation = UIDeviceOrientation.unknown
    
    var listActive: ListTask?
    
    @Binding var isAddNewList: Bool?
    @State private var showingAlert = false
    @Binding var listTitle: String
    
    var body: some View {
        VStack(alignment: .leading){
            
            VStack(alignment: .leading){
                
                Button(action: {
                    self.isShowingEditField.toggle()
                    isAddNewList = true
                }) {
                    Label("Add New List", systemImage: "plus")
                        .font(.system(size: 14))
                }
                .padding(.top, orientation.isLandscape ? 25 : 80)
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
                Button(action: {
                    self.isShowingEditField.toggle()
                    isAddNewList = false
                    listTitle = listActive?.title ?? ""
                }) {
                    Label("Edit Current List", systemImage: "pencil")
                        .font(.system(size: 14))
                }
                .padding(.top, 5)
                
                Button(" ✕  Remove Current List") {
                    showingAlert = true
                }
                .alert(isPresented:$showingAlert) {
                    Alert(
                        title: Text("Delete \(listActive?.title ?? "")?"),
                        primaryButton: .destructive(Text("Delete")) {
                            self.removeList()
                            if let firstList = lists.first {
                                self.setListActive(firstList)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .padding(.top, 5)
                .font(.system(size: 14))
                
                Divider().background(Color(red: 180/255, green: 180/255, blue: 180/255))
                
                ScrollView{
                    VStack{
                        ForEach(lists) { list in
                            HStack{
                                Text(list.wrapedTitle)
                                    .foregroundColor( colorTitleList(list.selected))
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .padding(.top, 5)
                            .onTapGesture {
                                setListActive(list)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 36/255, green: 36/255, blue: 36/255))
        .edgesIgnoringSafeArea(.all)
    }
    
    func colorTitleList(_ isActive: Bool) -> Color {
        if isActive {
            return Color.yellow
        } else {
            return Color(red: 180/255, green: 180/255, blue: 180/255)
        }
    }
    
    func setListActive(_ list: ListTask) {
        for listItem in lists {
            if list.id == listItem.id {
                listItem.selected = true
                continue
            }
            listItem.selected = false
        }
        
        saveContext()
    }
    
    func removeList(){
        guard let list = listActive else {return}
        moc.delete(list)
        saveContext()
    }
    
    func saveContext(){
        do {
            try self.moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


//
//  AdditingForm.swift
//  swiftui_coredata_v2
//
//  Created by pioner on 23.03.2021.
//

import SwiftUI

struct FormAdditingTask: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var titleText: String = ""
    
    var listActive: ListTask?
    
    var body: some View {
        HStack {
            TextField("New Task", text: $titleText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                addNewTask()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                    Text("Add")
                }
            }
        }
        .padding()
        .padding(.bottom, 10)
    }
    
    func addNewTask() {
        guard let lActive = listActive else {return}
        guard titleText != "" else {return}
        
        let task = Task(context: moc)
        task.title = titleText
        task.isCheck = false
        task.listTask = listActive
        task.number = getMaxNumberTask(list: lActive) + 1
        
        titleText = ""
        
        try? self.moc.save()
    }
    
    func getMaxNumberTask(list: ListTask) -> Int64 {
        var maxNum: Int64 = 0
        for task in list.taskArray {
            maxNum = (task.number > maxNum) ? task.number : maxNum
        }
        return maxNum
    }
}


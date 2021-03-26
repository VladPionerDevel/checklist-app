//
//  Cell.swift
//  swiftui_coredata_v2
//
//  Created by pioner on 24.03.2021.
//

import SwiftUI

struct Cell: View {
    
    @Environment(\.managedObjectContext) var moc
    
    var task: Task
    @State var taskCheck: Bool {
        didSet {
            task.isCheck = taskCheck
        }
    }
    
    init(task: Task) {
        self.task = task
        _taskCheck = State(initialValue: task.isCheck)
    }
    
    var body: some View {
        HStack{
            if taskCheck {
                Image(systemName: "checkmark.square.fill").resizable().frame(width: 25, height: 25).cornerRadius(5.0).foregroundColor(Color(UIColor.systemYellow))
            } else {
                Image(systemName: "square").resizable().frame(width: 25, height: 25).background(Color.clear).cornerRadius(5.0)
            }
            Text(task.wrapedTitle)
                .padding(.leading, 10).foregroundColor(Color(task.isCheck ? UIColor.systemGray3 : UIColor.label))
            Spacer()
        }
        .font(.title)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .contentShape(Rectangle())
        .onTapGesture {
            checkToggle(task)
        }
    }
    
    func checkToggle(_ task: Task){
        taskCheck.toggle()
        
        do {
            try self.moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


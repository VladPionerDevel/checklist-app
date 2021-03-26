//
//  CustomAlertView.swift
//  checklist_coredata
//
//  Created by pioner on 26.01.2021.
//

import SwiftUI



struct AlertAddEditList: View {
    
    @Binding var isShow: Bool
    @Binding var listTitle: String
    
    var geometry: GeometryProxy
    
    var action: (inout String) -> Void
    
    var body: some View {
        ZStack(){
            Rectangle()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color(UIColor.black))
                .opacity(self.isShow ? 0.3 : 0.0)
                .edgesIgnoringSafeArea(.all)
            
            HStack(alignment: .center){
                Spacer()
                VStack(alignment: .center) {
                    Text("List Name")
                    TextField("", text: self.$listTitle)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .id(self.isShow)
                    
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShow = false
                                action(&listTitle)
                            }
                        }) {
                            Text("OK")
                        }
                    }
                }
                .padding()
                .frame(width: geometry.size.width * 0.7)
                .background(Color(UIColor.systemBackground))
                .shadow(radius: CGFloat(1.0))
                .cornerRadius(20)
                Spacer()
            }
            
        }
        .disabled(!self.isShow)
        .opacity(self.isShow ? 1.0 : 0.0)
    }
}



//
//  ListRoomCardView.swift
//  7even
//
//  Created by Inez Amanda on 25/06/22.
//

import SwiftUI
import CloudKit

struct ListRoomCardView: View {
    
    @StateObject var vm: MainViewModel
    @Binding var room: RoomViewModel
    var isAddRoomButton = false
    @State var isActive = false
    @State var isPresented = false
    @State var roomCode = ""
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    let userID = UserDefaults.standard.object(forKey: "userID") as? String
    
    
    var body: some View {
        if(!isAddRoomButton) {
            Button(action: {
                print(userID)
                print(isPresented)
                if(room.isPrivateRoom && (room.participant.contains(userID!)) == false ){
                    self.isPresented = true
                    print("sini")
                } else {
                    print("Tap \(room.sport)")
                    print(room.participant)
                    self.isActive = true
                }
                
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(radius: 1.5)
                        .frame(width: 168, height: 127)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 5){
                            Text(room.sport)
                                .bold()
                            Text(room.region)
                                .font(.subheadline)
                            Text(dateFormatter.string(from: room.endTime))
                                .font(.footnote)
                        } //VSTACK
                        HStack(alignment: .center, spacing: 20) {
                            HStack {
                                // IF STATEMENT TO SET COMPETITIVE LEVEL COLOR
                                Circle()
                                    .fill(Color(UIColor.systemGreen))
                                    .frame(width: 9, height: 9)
                                
                                Text(room.levelOfPlay)
                                    .font(.caption)
                            }
                            
                            ZStack {
                                // IF STATEMENT TO SET PARTICIPANT COLOR
                                Circle()
                                    .strokeBorder(.mint)
                                    .frame(width: 30, height: 30)
                                Text("\(room.minimumParticipant)/\(room.maximumParticipant)")
                                    .font(.caption2)
                                    .foregroundColor(.mint)
                            }

                        } //HSTACK
                    } //VSTACK
                    .foregroundColor(Color.primary)
                    
                } //ZSTACK
            } //BUTTON
            .background(
                NavigationLink(destination: DetailRoomView(vm: self.vm, room: $room), isActive: $isActive, label: {
                    EmptyView()
                })
            )
            .background(
                AlertControl(textString: self.$roomCode, show: self.$isPresented, room: $room, isActive: $isActive,
                             title: "Private Sports Room", message: "You can get your room's code from the host")
            )
            .padding(.vertical, 5)
        }
        else {
            Button(action: {
                print("Tap \(room.sport)")
                self.isActive = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.mint)
                        .shadow(radius: 1.5)
                        .frame(width: 168, height: 127)
                    
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(.mint)
                } //ZSTACK
            } //BUTTON
            .background(
                NavigationLink(destination: CreateRoomView(vm: MainViewModel(container: CKContainer.default())), isActive: $isActive, label: {
                    EmptyView()
                })
            )
            .padding(.vertical, 5)
        }
        
    }
}

struct ListRoomCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

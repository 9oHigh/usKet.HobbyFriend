//
//  SocketManger.swift
//  usKet_HobbyFriend
//
//  Created by 이경후 on 2022/02/25.
//

import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    // 서버와 메세지를 주고받기 위한 클래스
    var manager: SocketManager!
    
    // 클라이언트 소켓
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        // 소켓위치 특정
        let url = URL(string: "http://test.monocoding.com:35484")!
        
        manager = SocketManager(socketURL: url, config: [
            .log(true),
            .compress
        ])
        
        socket = manager.defaultSocket // "/"로 된 룸 생성
        
        // 소켓 연결 메소드 , 연결 통로 만들기
        socket.on(clientEvent: .connect) { data, ack in
            
            print("IS CONNECTED", data, ack)
            
            self.socket.emit("changesocketid", UserDefaults.standard.string(forKey: "uid")!, completion: nil)
            
            print("UserDefault:", UserDefaults.standard.string(forKey: "uid")!)
        }
        
        // 소켓 연결 해제 메소드
        socket.on(clientEvent: .disconnect) { _, _ in }
        
        // 소켓 채팅을 처리, 즉 듣는 메소드로 chat 이벤트로 날아온 데이터를 수신
        // 데이터 수신 -> 디코딩 -> 모델에 추가 -> 갱신
        socket.on("chat") { dataArr, _ in
            // guard 구문써라 나중에
            let data = dataArr[0] as! NSDictionary
            let from = data["from"] as! String
            let to = data["to"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String
            let id = data["_id"] as! String
            let v = data["__v"] as! Int
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self, userInfo: [
                "from": from,
                "to": to,
                "chat": chat,
                "createdAt": createdAt,
                "_id": id,
                "__v": v
            ])
        }
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

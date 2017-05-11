//
//  BrokeSocket.swift
//  broker
//
//  Created by Eric Grassl on 5/5/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa
import SwiftSocket

class BrokeSocket: NSObject {
    
    public static let destinationIP = "127.0.0.1"
    public static let port = 25565
    //public static let queue = DispatchQueue.init(label: "background")
    
    static func backgroundServer(address: String, port: Int){
        let queue = DispatchQueue.init(label: "background")
        queue.async(){
            serverSocketApplication(address: address, port: Int32(25566))
        }
    }
    
    static func runOperation(){
        
    }
    
    static func serverSocketApplication(address: String, port: Int32){
        let server = TCPServer(address: address, port: port)
        switch server.listen(){
        case .success:
            while true{
                if let client = server.accept(){
                    let d = client.read(1024*10)
                    let message = String(bytes: d!, encoding: .utf8)
                    print(message!)
                    let mappedMessage = message!.components(separatedBy: ";")
                    switch mappedMessage[0] {
                    case "1":
                        //codigo ordem
                        break;
                    case "2":
                        let testeCliente = Cliente(id: String(mappedMessage[1].characters.dropLast(1)), nome: "")
                        if ClientPool.clienteExiste(novoCliente: testeCliente){
                            client.send(string: "true\n")
                        } else {
                            client.send(string: "false\n")
                        }
                        //codigo e cadastrado
                        break;
                        
                    default:
                        break;
                    }
                    client.close()
                } else {
                    print("deu ruim")
                }
            }
        case .failure(let error):
            print("deu erro")
        }
    }
    
    
    
    // Funcao que manda uma String para o dealBroker e retorna a resposta ou uma String vazia caso nao tenha resposta
    static func sendStringInSocket(destinationIP: String, port: Int, message:String) -> String{
        var socketMessage = message
        socketMessage.append("\n")
        let client = TCPClient(address: destinationIP, port: Int32(port))
        switch client.connect(timeout: 2) {
        case .success:
            switch client.send(string: socketMessage){
            case .success:
                guard let data = client.read(1024*10, timeout: 2) else {return ""}
                client.close()
                if let response = String(bytes: data, encoding: .utf8){
                    return response
                } else {
                    return ""
                }
            default: break
            }
            break
        default:
            break
        }
        client.close()
        return ""
    }
    
}

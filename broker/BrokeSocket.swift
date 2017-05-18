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
    
    static func serverSocketApplication(address: String, port: Int32){
        let server = TCPServer(address: address, port: port)
        switch server.listen(){
        case .success:
            while true{
                if let client = server.accept(){
                    let d = client.read(1024*10)
                    var message = String(bytes: d!, encoding: .utf8)!
                    print(message)
                    if message.characters.last == "\n"{
                        message = String(message.characters.dropLast(1)).lowercased()
                    }
                    let mappedMessage = message.components(separatedBy: ";")
                    switch mappedMessage[0] {
                    case "1":
                        break;
                    case "2":
                        let testeCliente = Cliente(id: mappedMessage[1], nome: "")
                        if ClientPool.clienteExisteNesteBroker(novoCliente: testeCliente){
                            client.send(string: "true\n")
                        } else {
                            client.send(string: "false\n")
                        }
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
                guard let data = client.read(1024*10, timeout: 30) else {return ""}
                client.close()
                if let response = String(bytes: data, encoding: .utf8){
                    if response.characters.last == "\n"{
                        //print("tirei o barra ene")
                        print(response)
                        return String(response.characters.dropLast(1)).lowercased()
                    }else {
                        return response.lowercased()
                    }
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
    
    static func updateOrdens(destinationIP: String, port: Int, intervalo: Int){
        let idOperacao = "7"
        var message = ""
        let cliente = ClientPool.getClienteAtivo()
        let idBroker = "3"
        var idOrdem: String
        var resposta: String
        var mappedResposta: [String]
        var listaOrdens = cliente.orderns
        for ordem in listaOrdens{
            
            //print(String(describing: cliente.orderns.index(of: ordem)!))
            idOrdem = cliente.id + ":" + (String(ordem.id))
            message = idOperacao + ";" + idBroker + ";" + idOrdem + "\n"
            resposta = sendStringInSocket(destinationIP: destinationIP, port: port, message: message)
            mappedResposta = resposta.components(separatedBy: ";")
            if resposta != ""{
                ClientPool.updateOrdem(ordem: ordem, status: mappedResposta[0], saldo: mappedResposta[1])
            }
            print("mensagem: " + message)
        }
        
    }
    
}

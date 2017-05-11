//
//  ClientPool.swift
//  broker
//
//  Created by Eric Grassl on 5/1/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class ClientPool: NSObject {
    static private var clientes = Array<Cliente>()
    static private var activeClient = -1
    
    static public func clienteExiste(novoCliente: Cliente) -> Bool{
        let mensagem = "2;3;" + novoCliente.id
        let resposta = String(BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: mensagem).characters.dropLast(1))
        let mappedResposta = resposta.components(separatedBy: ";")
        if mappedResposta[1] == "true"{
            return true
        }
        
        for cliente in self.clientes{
            if(cliente.id == novoCliente.id || cliente.contaBroker.getLogin() == novoCliente.contaBroker.getLogin()){
                return true
            }
        }
        return false
    }
    
    static public func adicionaCliente(novoCliente: Cliente) -> Bool{
        if self.clienteExiste(novoCliente: novoCliente){
            return false
        }
        self.clientes.append(novoCliente)
        return true
    }
    
    static public func ativaLogin(login: String, senha: String) -> Bool{
        for cliente in self.clientes{
            if cliente.contaBroker.autoriza(login: login, senha: senha){
                if self.activeClient != -1 && self.activeClient != self.clientes.index(of: cliente){
                    self.clientes[self.activeClient].contaBroker.desautorizar()
                }
                self.activeClient = clientes.index(of: cliente)!
                //print(activeClient)
                //print(clientes[activeClient].contaBroker.estaAutorizado())
                return true;
            }
        }
        return false;
    }
    
    static public func getClienteAtivo() -> Cliente{
        if self.activeClient != -1{
            return self.clientes[self.activeClient]
        }
        return Cliente()
    }
    
    static public func efectuaOrdem(id: String, message: [String] ){
        var index = -1
        for cliente in self.clientes{
            if cliente.id == id{
                index = self.clientes.index(of: cliente)!
            }
        }
        if index == -1 {
            return
        }
        
        
    }
}

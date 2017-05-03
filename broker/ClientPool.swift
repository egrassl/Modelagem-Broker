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
        for cliente in self.clientes{
            if(cliente.id == novoCliente.id){
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
                if self.activeClient != -1{
                    self.clientes[self.activeClient].contaBroker.desautorizar()
                }
                self.activeClient = clientes.index(of: cliente)!
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
}

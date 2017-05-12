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
    
    static public func efetuaOrdem(message: [String] ){
        var indexCliente = -1
        let id = message[0]
        let idOrdem = message[1]
        let tipo = message[2]
        let empresa = message[3]
        let quantidade = message[4]
        let preco = String(message[5].characters.dropLast(1))
        
        let internalID = idOrdem.components(separatedBy: ":")
        let cpf = internalID[0]
        let indexOrdem = internalID[1]
    
        for cliente in self.clientes{
            if cliente.id == cpf{
                indexCliente = self.clientes.index(of: cliente)!
            }
        }
        if indexCliente == -1 {
            return
        }
        
        let cliente = self.clientes[indexCliente]
        
        let ordem = cliente.orderns[Int(indexOrdem)!]
        
        
        //novo metodo
        var indexAcao = -1;
        let acoes = cliente.carteira.getAcoes()
        for acao in acoes{
            if(acao.getNomeEmpresa() == empresa){
                indexAcao = acoes.index(of: acao)!
            }
        }
        if indexAcao == -1{
            return
        }
        
        //let indexacao = cliente.carteira.getAcoes().index(of: ordem.acao)
        var acao = cliente.carteira.getAcoes()[indexAcao]
        switch tipo {
        case "COMPRA":
            if ordem.acao.getQuantidade() > Int(quantidade)!{
                acao.addQuantidade(quantidade: Int(quantidade)!)
                ordem.acao.addQuantidade(quantidade: -Int(quantidade)!)
                //cliente.carteira.addSaldo(s: Double(preco)!*Double(quantidade)!)
            } else {
                cliente.orderns.remove(at: Int(indexOrdem)!)
                acao.addQuantidade(quantidade: ordem.acao.getQuantidade())
                //cliente.carteira.addSaldo(s: Double(ordem.acao.getQuantidade())*ordem.valor)
            }
        case "VENDA":
            if ordem.acao.getQuantidade() > Int(quantidade)!{
                ordem.acao.addQuantidade(quantidade: -Int(quantidade)!)
                cliente.carteira.addSaldo(s: Double(quantidade)!*Double(preco)!)
            } else {
                cliente.orderns.remove(at: Int(indexOrdem)!)
                cliente.carteira.addSaldo(s: Double(ordem.acao.getQuantidade())*ordem.valor)
            }
            break;
            
        default:
            break;
        }
        
        
    }
}

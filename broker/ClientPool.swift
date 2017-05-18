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
    
    static public func clienteExisteEmOutrosBrokers(novoCliente: Cliente) -> Bool{
        let mensagem = "2;3;" + novoCliente.id
        let resposta = BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: mensagem)
        //let mappedResposta = resposta.components(separatedBy: ";")
        //if mappedResposta[1] == "true"{
        //    return true
        //}
        if resposta == "true"{
            return true
        }
        return false;
    }
    
    static public func clienteExisteNesteBroker(novoCliente: Cliente) -> Bool{
        for cliente in self.clientes{
            if(cliente.id == novoCliente.id || cliente.contaBroker.getLogin() == novoCliente.contaBroker.getLogin()){
                return true
            }
        }
        return false
    }
    
    static public func clienteExiste(novoCliente: Cliente) -> Bool{
        let clienteEmOutrosBrokers = clienteExisteEmOutrosBrokers(novoCliente: novoCliente)
        let clienteNesteBroker = clienteExisteNesteBroker(novoCliente: novoCliente)
        if clienteEmOutrosBrokers || clienteNesteBroker{
            return true
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
    
    
    static public func updateOrdem(ordem: Ordem, status: String, saldo: String) {
        let cliente = ClientPool.getClienteAtivo()
        switch status {
        case "efetuada":
            if ordem.tipo == 1{
                efetuaOrdemCompra(cliente: cliente, ordem: ordem)
            } else {
                efetuaOrdemVenda(cliente: cliente, ordem: ordem)
            }
            break;
        case "cancelada":
            if ordem.tipo == 1{
                cancelarOrdemCompra(cliente: cliente, ordem: ordem, saldo: Int(saldo)!)
            } else {
                cancelarOrdemVenda(cliente: cliente, ordem: ordem, saldo: Int(saldo)!)
            }
            break;
        default:
            break;
        }
        
    }
    
    static public func cancelarOrdemVenda(cliente: Cliente, ordem: Ordem, saldo: Int){
        let quantidade = ordem.acao.getQuantidade() - saldo
        let lucro = Double(quantidade) * ordem.valor
        let indexAcao = getIndexAcaoWith(name: ordem.acao.getNomeEmpresa(), from: cliente)
        if indexAcao == -1{
            return
        }
        
        let acao = cliente.carteira.getAcoes()[indexAcao]
        acao.addQuantidade(quantidade: saldo)
        cliente.carteira.addSaldo(s: lucro)
        delete(ordem: ordem, from: cliente)
    }
    
    static public func efetuaOrdemVenda(cliente: Cliente, ordem: Ordem){
        cliente.carteira.addSaldo(s: Double(ordem.acao.getQuantidade()) * ordem.valor)
        delete(ordem: ordem, from: cliente)
    }
    
    static public func cancelarOrdemCompra(cliente: Cliente, ordem: Ordem, saldo: Int){
        let quantidade = ordem.acao.getQuantidade() - saldo
        let indexAcao = getIndexAcaoWith(name: ordem.acao.getNomeEmpresa(), from: cliente)
        if indexAcao == -1{
            return
        }
        let acao = cliente.carteira.getAcoes()[indexAcao]
        acao.addQuantidade(quantidade: quantidade)
        
        cliente.carteira.addSaldo(s: Double(saldo) * ordem.valor)
        delete(ordem: ordem, from: cliente)
    }
    
    static public func efetuaOrdemCompra(cliente: Cliente, ordem: Ordem){
        
        //acha a acao na carteira do cliente ativo
        let indexAcao = getIndexAcaoWith(name: ordem.acao.getNomeEmpresa(), from: cliente)
        if indexAcao == -1{
            return
        }
        
        let acao = cliente.carteira.getAcoes()[indexAcao]
        acao.addQuantidade(quantidade: ordem.acao.getQuantidade())
        delete(ordem: ordem, from: cliente)
    }
    
    static public func getIndexAcaoWith(name: String, from: Cliente) -> Int{
        let cliente = from
        var indexAcao = -1
        for acao in cliente.carteira.getAcoes(){
            if(acao.getNomeEmpresa() == name){
                indexAcao = cliente.carteira.getAcoes().index(of: acao)!
            }
        }
        return indexAcao
    }
    
    static public func delete(ordem: Ordem, from: Cliente){
        let cliente = from
        let indexOrdem = cliente.orderns.index(of: ordem)
        cliente.orderns.remove(at: indexOrdem!)
    }
    
}

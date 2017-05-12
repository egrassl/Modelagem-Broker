//
//  Cliente.swift
//  broker
//
//  Created by Eric Grassl on 4/30/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa
import SwiftSocket

class Cliente: NSObject {
    
    var contaBroker: Conta
    var id: String
    var nome: String
    var orderns = Array<Ordem>()
    var carteira:Carteira
    let queue = DispatchQueue.init(label: "cliente")
    
    init(id: String = "", nome: String = "", contaBanco: String = "") {
        contaBroker = Conta()
        self.id = id
        self.nome = nome
        self.carteira = Carteira(queue: self.queue, contaBanco: contaBanco)
        super.init()
        let startNumber = 1000
        let empresas = ["KUAT", "SONY", "NASA", "VALE", "ITAU", "NIKE", "DELL", "ASUS", "FIAT", "FORD"]
        for empresa in empresas {
            self.carteira.addAcao(empresa: empresa, quantidade: startNumber)
        }
    }
    
    public func efetuarOrdem(acao: Acao, valor: Double, quantidade: Int,tipo: Int) -> Bool{
        
        let pregaoAberto = String(BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: "4\n").characters.dropLast(1))
        //print(pregaoAberto)
        if pregaoAberto == "FECHADO"{
            return false
        }
        
        let indexAcao = self.carteira.getAcoes().index(of: acao)
        if (self.carteira.getAcoes()[indexAcao!].getQuantidade() < quantidade && tipo == 2) || ( Double(quantidade) * valor > self.carteira.getSaldo() && tipo == 1){
            return false
        }
        

        var sTipo = ""
        if tipo == 1{
            sTipo = "COMPRA"
            self.carteira.addSaldo(s: -(Double(quantidade)*valor))
        } else {
            sTipo = "VENDA"
            self.carteira.getAcoes()[indexAcao!].addQuantidade(quantidade: -quantidade)
        }
        
        //self.carteira.getAcoes()[indexAcao!].set -= quantidade
        
        
        let novaAcao = Acao(empresa: acao.getNomeEmpresa(), quantidade: quantidade, queue: self.queue)
        let novaOrdem = Ordem(acao: novaAcao, valor: valor, tipo: tipo)
        self.orderns.append(novaOrdem)
        
        //codigo socket aqui
        
        
        let idOrdem = String(self.id) + ":" + String(describing: orderns.index(of: novaOrdem)!)
        let message = "1;" + "3;" + idOrdem + ";" + sTipo + ";" + String(novaAcao.getNomeEmpresa()) + ";" + String(novaAcao.getQuantidade()) + ";" + String(novaOrdem.valor) + "\n"
        BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: message)
        return true
    }
    
    public func removerOrdem(){
        
    }
    
    public func obterRelatorioAcoes() -> String{
        var output = ""
        for acao in self.carteira.getAcoes(){
            output += "Nome: \(acao.getNomeEmpresa())\n"
            output += "Quantidade: \(acao.getQuantidade())\n\n"
        }
        output = String(output.characters.dropLast(2))
        return output
    }
    
    public func obterRelatorioOrdens() -> String{
        var output = ""
        for ordem in self.orderns{
            output += "Nome: \(ordem.acao.getNomeEmpresa())\n"
            switch ordem.tipo {
            case 1:
                output += "Tipo: Compra\n"
                break
            case 2:
                output += "Tipo: Venda\n"
                break
            default:
                break
            }
            output += "Quantidade: \(ordem.acao.getQuantidade())\n"
            output += "Valor: \(ordem.valor)\n\n"
        }
        if output == ""{
            output = "Não há ordens!"
        }else{
            output = String(output.characters.dropLast(2))
        }
        return output
    }
    
    public func gerenciaConta(){
        
    }
    
//    public func criarConta(login: String, senha: String){
//        self.contaBroker.efetivaConta(login: login, senha: senha)
//    }
}

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
    var carteira = Carteira()
    let queue = DispatchQueue.init(label: "cliente")
    
    init(id: String = "", nome: String = "") {
        contaBroker = Conta()
        self.id = id
        self.nome = nome
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
        if (self.carteira.getAcoes()[indexAcao!].quantidade < quantidade && tipo == 2) || ( Double(quantidade) * valor > self.carteira.getSaldo() && tipo == 1){
            return false
        }
        self.carteira.getAcoes()[indexAcao!].quantidade -= quantidade
        
        let novaAcao = Acao(empresa: acao.empresa, quantidade: quantidade)
        let novaOrdem = Ordem(acao: novaAcao, valor: valor, tipo: tipo)
        self.orderns.append(novaOrdem)
        
        //codigo socket aqui
        
        let idOrdem = String(self.id) + ":" + String(describing: orderns.index(of: novaOrdem)!)
        var sTipo = ""
        if tipo == 1{
            sTipo = "COMPRA"
        } else {
            sTipo = "VENDA"
        }
        
        let message = "1;" + "3;" + idOrdem + ";" + sTipo + ";" + String(novaAcao.empresa) + ";" + String(novaAcao.quantidade) + ";" + String(novaOrdem.valor) + "\n"
        BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: message)
        return true
    }
    
    public func removerOrdem(){
        
    }
    
    public func obterRelatorio(){
        
    }
    
    public func gerenciaConta(){
        
    }
    
    public func criarConta(login: String, senha: String, contaBanco: String){
        self.contaBroker.efetivaConta(login: login, senha: senha, contaBanco: contaBanco)
    }
}

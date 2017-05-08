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
    private var acoes = Array<Acao>()
    var orderns = Array<Ordem>()
    
    init(id: String = "", nome: String = "") {
        contaBroker = Conta()
        self.id = id
        self.nome = nome
        super.init()
        var startNumber = 1000
        self.addAcao(empresa: "Coca Cola", quantidade: startNumber)
        self.addAcao(empresa: "Guaraná", quantidade: startNumber)
    }
    
    public func efetuarOrdem(acao: Acao, valor: Double, quantidade: Int,tipo: Int) -> Bool{
        let indexAcao = acoes.index(of: acao)
        if acoes[indexAcao!].quantidade < quantidade{
            return false
        }
        
        acoes[indexAcao!].quantidade -= quantidade
        
        let novaAcao = Acao(empresa: acao.empresa, quantidade: quantidade)
        let novaOrdem = Ordem(acao: novaAcao, valor: valor, tipo: tipo)
        self.orderns.append(novaOrdem)
        
        //codigo socket aqui
        var message = String(tipo) + " | " + String(novaOrdem.valor) + " | " + novaOrdem.acao.empresa + " | " + String(novaOrdem.acao.quantidade)
        BrokeSocket.sendStringInSocket(destinationIP: "127.0.0.1", port: 25565, message: message)
        
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
    
    public func addAcao(empresa: String, quantidade: Int){
        let acao = Acao(empresa: empresa, quantidade: quantidade)
        self.acoes.append(acao)
    }
    
    public func getAcoes() -> Array<Acao>{
        return acoes;
    }
}

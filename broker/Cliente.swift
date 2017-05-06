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
    }
    
    public func efetuarOrdem(acao: Acao, valor: Double, tipo: Int) -> Bool{
        let indexAcao = acoes.index(of: acao)
        if acoes[indexAcao!].quantidade < acao.quantidade{
            return false
        }
        let novaOrdem = Ordem(acao: acoes[indexAcao!], valor: valor, tipo: tipo)
        self.orderns.append(novaOrdem)
        //codigo socket aqui
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

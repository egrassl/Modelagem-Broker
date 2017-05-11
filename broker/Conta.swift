//
//  Conta.swift
//  broker
//
//  Created by Eric Grassl on 4/30/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class Conta: NSObject {
    
    private var estaLogado = false
    private var login = ""
    private var senha = ""
    
    public func estaAutorizado() -> Bool{
        return self.estaLogado
    }
    
    public func autoriza(login: String, senha: String) -> Bool{
        if  self.login == login && self.senha == senha{
            self.estaLogado = true
            return true
        } else {
            return false
        }
    }
    
    public func desautorizar(){
        self.estaLogado = false
    }
    
    
    public func efetivaConta(login: String, senha: String, contaBanco: String){
        self.estaLogado = true
        self.login = login
        self.senha = senha
    }
    
    public func getLogin() -> String{
        return self.login
    }
    
}

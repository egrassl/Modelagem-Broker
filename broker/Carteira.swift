//
//  Carteira.swift
//  broker
//
//  Created by Eric Grassl on 5/9/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class Carteira: NSObject {
    
    private var saldo : Double
    private var contaBanco: String
    private var acoes = Array<Acao>()
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue) {
        self.saldo = 0
        self.contaBanco = ""
        self.queue = queue
    }
    
    public func addAcao(empresa: String, quantidade: Int){
        let acao = Acao(empresa: empresa, quantidade: quantidade, queue: self.queue)
        self.acoes.append(acao)
        
    }
    
    public func getAcoes() -> Array<Acao>{
        return acoes
    }
    
    
    public func getSaldo() -> Double{
        return saldo
    }

    public func setSaldo(s: Double){
        self.queue.sync {
            self.saldo = s;
        }
    }
    
    public func addSaldo(s: Double){
        self.queue.sync {
            self.saldo += s
        }
    }
    
}

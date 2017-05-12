//
//  Acao.swift
//  broker
//
//  Created by Eric Grassl on 5/2/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class Acao: NSObject {
    private var empresa: String
    //var id: Int
    private var quantidade: Int
    private var queue: DispatchQueue
    
    init(empresa: String, quantidade: Int, queue: DispatchQueue){
        self.empresa = empresa
        //self.id = id
        self.quantidade = quantidade
        self.queue = queue
    }
    
    public func setNomeEmpresa(nome: String){
        
    }
    
    public func setQuantidade(quantidade: Int){
        
    }
    
    public func addQuantidade(quantidade: Int){
        self.quantidade += quantidade
    }
    
    public func getQuantidade() -> Int{
        return self.quantidade
    }
    
    public func getNomeEmpresa() -> String{
        return self.empresa
    }
}

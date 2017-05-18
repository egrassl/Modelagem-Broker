//
//  Ordem.swift
//  broker
//
//  Created by Eric Grassl on 5/3/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class Ordem: NSObject {
    var acao: Acao
    var	valor: Double
    var tipo: Int
    var id: Int
    
    init(acao: Acao, valor: Double, tipo: Int, id: Int){
        self.acao = acao
        self.valor = valor
        self.tipo = tipo
        self.id = id
    }
    
}

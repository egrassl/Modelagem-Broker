//
//  Acao.swift
//  broker
//
//  Created by Eric Grassl on 5/2/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class Acao: NSObject {
    var empresa: String
    //var id: Int
    var quantidade: Int
    
    init(empresa: String, quantidade: Int){
        self.empresa = empresa
        //self.id = id
        self.quantidade = quantidade
    }
}

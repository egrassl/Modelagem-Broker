//
//  OrdemController.swift
//  broker
//
//  Created by Eric Grassl on 4/30/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class OrdemController: NSViewController {
    
    var tipo = 0
    @IBOutlet weak var botaoAcao: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if tipo == 1 {
            self.title = "Efetuar Ordem de Compra"
            botaoAcao.title = "Comprar"
        } else if tipo == 2 {
            self.title = "Efetuar Ordem de Venda"
            botaoAcao.title = "Vender"
        }
    }
    
    @IBAction func botaoCancelarPressionado(_ sender: Any) {
        self.view.window?.close()
    }
    
}

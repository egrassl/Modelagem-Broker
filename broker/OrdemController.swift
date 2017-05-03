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
    @IBOutlet weak var botaoAcoes: NSPopUpButton!
    
    @IBOutlet weak var preco: NSTextField!
    @IBOutlet weak var quantidade: NSTextField!
    
    let acoes = ClientPool.getClienteAtivo().getAcoes()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if tipo == 1 {
            self.title = "Efetuar Ordem de Compra"
            botaoAcao.title = "Comprar"
            quantidade.isEditable = false
        } else if tipo == 2 {
            self.title = "Efetuar Ordem de Venda"
            botaoAcao.title = "Vender"
        }
        
        for acao in acoes{
            let itemString = acao.empresa
            botaoAcoes.addItem(withTitle: itemString)
        }
        quantidade.stringValue = String(acoes[botaoAcoes.indexOfSelectedItem].quantidade)
    }
    
    @IBAction func botaoCancelarPressionado(_ sender: Any) {
        self.view.window?.close()
    }
    
    @IBAction func selecionarItem(_ sender: NSPopUpButton) {
        quantidade.stringValue = String(acoes[botaoAcoes.indexOfSelectedItem].quantidade)
    }
    
}

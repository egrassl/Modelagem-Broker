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
    
    let acoes = ClientPool.getClienteAtivo().carteira.getAcoes()

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
        
        for acao in acoes{
            let itemString = acao.empresa
            botaoAcoes.addItem(withTitle: itemString)
        }
        quantidade.stringValue = String(acoes[botaoAcoes.indexOfSelectedItem].quantidade)
    }
    
    func messageBox(message: String){
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
    
    @IBAction func botaoCancelarPressionado(_ sender: Any) {
        self.view.window?.close()
    }
    
    @IBAction func selecionarItem(_ sender: NSPopUpButton) {
        quantidade.stringValue = String(acoes[botaoAcoes.indexOfSelectedItem].quantidade)
    }
    
    @IBAction func efetuarOrdem(_ sender: Any) {
        let cliente = ClientPool.getClienteAtivo()
        let acao = acoes[botaoAcoes.indexOfSelectedItem]
        if cliente.efetuarOrdem(acao: acao, valor: preco.doubleValue, quantidade: Int(quantidade.intValue), tipo: tipo){
            messageBox(message: "Ordem efetuada com sucesso!")
            self.view.window?.close()
        } else {
            messageBox(message: "Erro ao efetuar Ordem!")
        }
    }
    
}

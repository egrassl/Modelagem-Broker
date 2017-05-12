//
//  RelatorioController.swift
//  broker
//
//  Created by Eric Grassl on 5/9/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class RelatorioController: NSViewController {
    @IBOutlet var acoesTextView: NSTextView!

    @IBOutlet var ordensTextView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        updateAcoes()
        updateOrdens()
        
        
        
    }
    
    func updateAcoes(){
        let cliente = ClientPool.getClienteAtivo()
        let output = cliente.obterRelatorioAcoes()
        self.acoesTextView.textStorage?.mutableString.setString(output)
        self.acoesTextView.isEditable = false
    }
    
    func updateOrdens(){
        let cliente = ClientPool.getClienteAtivo()
        let output = cliente.obterRelatorioOrdens()
        self.ordensTextView.textStorage?.mutableString.setString(output)
        self.ordensTextView.isEditable = false
    }
    
}

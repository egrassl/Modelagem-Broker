//
//  GerenciaContaController.swift
//  broker
//
//  Created by Eric Grassl on 5/1/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class GerenciaContaController: NSViewController {
    @IBOutlet weak var nome: NSTextField!

    @IBOutlet weak var cpf: NSTextField!
    
    @IBOutlet weak var saldo: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let cliente = ClientPool.getClienteAtivo()
        if cliente.contaBroker.estaAutorizado(){
            nome.stringValue = cliente.nome
            cpf.stringValue = cliente.id
            saldo.doubleValue = cliente.carteira.getSaldo()
        } else {
            nome.stringValue = "deu bosta"
        }
        
    }
    @IBAction func depositoButton(_ sender: Any) {
        performSegue(withIdentifier: "deposito", sender: self)
        self.view.window?.close()
    }
    
    @IBAction func cancelar(_ sender: Any) {
        self.view.window?.close()
    }
    
}

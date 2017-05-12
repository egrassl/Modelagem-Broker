//
//  DepositoController.swift
//  broker
//
//  Created by Eric Grassl on 5/9/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class DepositoController: NSViewController {

    @IBOutlet weak var valDeposito: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func messageBox(message: String){
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
    
    @IBAction func confirmarDeposito(_ sender: Any) {
        if valDeposito.doubleValue > 0{
            ClientPool.getClienteAtivo().carteira.addSaldo(s: valDeposito.doubleValue)
            performSegue(withIdentifier: "gerencia", sender: self)
            self.view.window?.close()
        } else {
            messageBox(message: "Não foi possivel efetuar a operação")
        }
    }
    
    @IBAction func cancelar(_ sender: Any) {
        performSegue(withIdentifier: "deposito", sender: self)
        self.view.window?.close()
    }
    
}

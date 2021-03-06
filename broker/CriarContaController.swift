//
//  CriarContaController.swift
//  broker
//
//  Created by Eric Grassl on 5/1/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class CriarContaController: NSViewController {

    @IBOutlet weak var nome: NSTextField!
    
    @IBOutlet weak var cpf: NSTextField!
    
    @IBOutlet weak var contaBanco: NSTextField!
    
    @IBOutlet weak var nomeUsuario: NSTextField!
    
    @IBOutlet weak var senha: NSSecureTextField!
    
    @IBOutlet weak var confirmarSenha: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
       
    }
    
    func messageBox(message: String){
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
    
    @IBAction func confirmarCriacao(_ sender: NSButton) {
        let novoCliente = Cliente(id: cpf.stringValue, nome: nome.stringValue, contaBanco: contaBanco.stringValue)
        if nome.stringValue.isEmpty || cpf.stringValue.isEmpty || contaBanco.stringValue.isEmpty || nomeUsuario.stringValue.isEmpty || senha.stringValue.isEmpty || confirmarSenha.stringValue.isEmpty {
            self.messageBox(message: "Preenchimento incompleto!")
            return
        } else if senha.stringValue != confirmarSenha.stringValue {
            self.messageBox(message: "A confirmação de senha está incorreta, tentar novamente")
            return
        } else {
            novoCliente.contaBroker.efetivaConta(login: nomeUsuario.stringValue, senha: senha.stringValue)
            if ClientPool.adicionaCliente(novoCliente: novoCliente) == false{
                self.messageBox(message: "Cliente ou conta já existente. Tente novamente!")
                return
            }
            ClientPool.ativaLogin(login: nomeUsuario.stringValue, senha: senha.stringValue)
            self.messageBox(message: "Cliente adicionado com sucesso!")
            self.view.window?.close()
        }
    }
    
    @IBAction func cancelarCriacao(_ sender: NSButton) {
        self.view.window?.close()
    }
}

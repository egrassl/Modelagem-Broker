//
//  LoginController.swift
//  broker
//
//  Created by Eric Grassl on 5/2/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class LoginController: NSViewController {

    @IBOutlet weak var nomeUsuario: NSTextField!
    
    @IBOutlet weak var senha: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func messageBox(message: String){
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
    
    @IBAction func confirmarLogin(_ sender: NSButton) {
        if nomeUsuario.stringValue.isEmpty || senha.stringValue.isEmpty{
            messageBox(message: "Todos os campos devem ser preenchidos!")
        } else if ClientPool.ativaLogin(login: nomeUsuario.stringValue, senha: senha.stringValue){
            messageBox(message: "Login efetuado com sucesso!")
            self.view.window?.close()
        } else {
            messageBox(message: "Nome de usuário ou senha incorretos!")
        }
    }
    
    @IBAction func cancelar(_ sender: Any) {
        self.view.window?.close()
    }
    
}

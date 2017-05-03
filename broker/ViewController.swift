//
//  ViewController.swift
//  broker
//
//  Created by Eric Grassl on 4/30/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var botaoCompra: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "ordemCompra" {
            if let destinationVC = segue.destinationController as? OrdemController {
                destinationVC.tipo = 1;
            }
        } else if  segue.identifier == "ordemVenda"{
            if let destinationVC = segue.destinationController as? OrdemController {
                destinationVC.tipo = 2;
            }
        }
    }
    
    func messageBox(message: String){
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
    
    @IBAction func botaoPressionado(_ sender: NSButton) {
        if ClientPool.getClienteAtivo().contaBroker.estaAutorizado(){
            switch sender.title {
                case "Efetuar Ordem de Compra":
                    performSegue(withIdentifier: "ordemCompra", sender: sender)
                    break
                case "Efetuar Ordem de Venda":
                    performSegue(withIdentifier: "ordemVenda", sender: sender)
                    break
                case "Gerenciar Conta":
                    performSegue(withIdentifier: "gerenciarConta", sender: sender)
                    break
                default:
                    break
            }
        } else {
            messageBox(message: "Você precisa estar logado para poder efetuar esta operação!")
        }
    }
    
    
}


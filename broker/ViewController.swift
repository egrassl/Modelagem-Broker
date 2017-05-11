//
//  ViewController.swift
//  broker
//
//  Created by Eric Grassl on 4/30/17.
//  Copyright © 2017 egrassl. All rights reserved.
//

import Cocoa
import SwiftSocket

class ViewController: NSViewController {
    @IBOutlet weak var botaoCompra: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BrokeSocket.backgroundServer(address: BrokeSocket.destinationIP, port: BrokeSocket.port)
        //print(BrokeSocket.sendStringInSocket(destinationIP: "127.0.0.1", port: 25565, message: "Oi\nOi\n"))
        
        let message = String(BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: "5\n").characters.dropLast(1))
        print("mensagem: \(message)")
        let acoes = message.components(separatedBy: ";")
        
        var i = 1;
        while i < acoes.count{
            print("nome: " + acoes[i])
            i += 1
            print("valor: " + acoes[i])
            i += 1
            print("quantidade: " + acoes[i])
            i += 1
            print("data: " + acoes[i])
            i += 1
            print("porcentagem: " + acoes[i])
            i += 1
            print("")
        }
        
//        print(BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: "2;3;11111111111"))
//        print(BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: "2;3;1111112211"))
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
                case "Relatório":
                    performSegue(withIdentifier: "relatorio", sender: self)
                    break
                default:
                    break
            }
        } else {
            messageBox(message: "Você precisa estar logado para poder efetuar esta operação!")
        }
    }
    
    @IBAction func fechar(_ sender: Any) {
        NSApp.terminate(self)
    }
    
}


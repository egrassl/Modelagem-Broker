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
    

    @IBOutlet var textView: NSTextView!
    let queue = DispatchQueue.global()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.textView.isEditable = true
//        self.textView.insertText(updateAcoes())
//        self.textView.isEditable = false
        BrokeSocket.backgroundServer(address: BrokeSocket.destinationIP, port: BrokeSocket.port)
        
        self.updateAcoes()
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func updateAcoes(){
        let message = BrokeSocket.sendStringInSocket(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, message: "5\n")
        //print("mensagem: \(message)")
        let acoes = message.components(separatedBy: ";")
        var resposta = ""
        var i = 1;
        while i < acoes.count{
            //print("nome: " + acoes[i])
            resposta += "Nome: " + acoes[i] + "\n"
            i += 1
            //print("valor: " + acoes[i])
            resposta += "Valor: " + acoes[i] + "\n"
            i += 1
            //print("quantidade: " + acoes[i])
            resposta += "Quantidade: " + acoes[i] + "\n"
            i += 1
            //print("data: " + acoes[i])
            resposta += "Tipo: " + acoes[i] + "\n\n"
            i += 1
            //print("")
        
        }
        resposta = String(resposta.characters.dropLast(2))
        self.textView.isEditable = true
        self.textView.textStorage?.mutableString.setString(resposta)
        //self.textView.insertText(resposta)
        self.textView.isEditable = false
    }
    
    @IBAction func updateAcoes(_ sender: Any) {
        self.updateAcoes()
        BrokeSocket.updateOrdens(destinationIP: BrokeSocket.destinationIP, port: BrokeSocket.port, intervalo: 20)
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


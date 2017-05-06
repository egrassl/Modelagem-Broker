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
        let client = TCPClient(address: "localhost", port: 25565)
        print(sendStringWithResponseInSocket(destinationIP: "localhost", port: 25565, message: "Bom dia!"))
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func sendStringWithResponseInSocket(destinationIP: String, port: Int, message:String) -> String{
        var socketMessage = message
        socketMessage.append("\n|")
        let client = TCPClient(address: destinationIP, port: Int32(port))
        switch client.connect(timeout: 2) {
        case .success:
            switch client.send(string: socketMessage){
            case .success:
                guard let data = client.read(1024*10, timeout: 2) else {return ""}
                client.close()
                if let response = String(bytes: data, encoding: .utf8){
                    return response
                } else {
                    return ""
                }
            default: break
            }
            break
        default:
            break
        }
        client.close()
        return ""
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
    
    @IBAction func fechar(_ sender: Any) {
        NSApp.terminate(self)
    }
    
}


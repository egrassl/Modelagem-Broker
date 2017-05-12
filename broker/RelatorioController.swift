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
        var output = ""
        for acao in cliente.carteira.getAcoes(){
            output += "Nome: \(acao.getNomeEmpresa())\n"
            output += "Quantidade: \(acao.getQuantidade())\n\n"
        }
        output = String(output.characters.dropLast(2))
        self.acoesTextView.textStorage?.mutableString.setString(output)
        self.acoesTextView.isEditable = false
    }
    
    func updateOrdens(){
        let cliente = ClientPool.getClienteAtivo()
        var output = ""
        for ordem in cliente.orderns{
            output += "Nome: \(ordem.acao.getNomeEmpresa())\n"
            switch ordem.tipo {
            case 1:
                output += "Tipo: Compra\n"
                break
            case 2:
                output += "Tipo: Venda\n"
                break
            default:
                break
            }
            output += "Quantidade: \(ordem.acao.getQuantidade())\n"
            output += "Valor: \(ordem.valor)\n\n"
        }
        if output == ""{
            output = "Não há ordens!"
        }else{
            output = String(output.characters.dropLast(2))
        }
        self.ordensTextView.textStorage?.mutableString.setString(output)
        self.ordensTextView.isEditable = false
    }
    
}

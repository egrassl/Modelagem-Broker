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
    
    @IBAction func ordemPressed(_ sender: NSButton) {
        if sender.title == "Efetuar Ordem de Compra"{
            performSegue(withIdentifier: "ordemCompra", sender: sender)
        } else if sender.title == "Efetuar Ordem de Venda" {
            performSegue(withIdentifier: "ordemVenda", sender: sender)
        }
    }
    
    


}


//
//  ViewController.swift
//  Projeto-Ferias-Quadro-Fotos-Iluminado-iOS
//
//  Created by Humberto Vieira de Castro on 6/27/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    //Inicializa variaveis
    let _centralManager = CBCentralManager()
    let _selectedPeripheral = CBPeripheral()
    
    /*
        FUNCOES PARA ACESSAR O BLUETOOTH
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

/**/
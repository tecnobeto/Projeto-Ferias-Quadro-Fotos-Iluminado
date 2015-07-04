//
//  QuadrosViewController.swift
//  Projeto-Ferias-Quadro-Fotos-Iluminado-iOS
//
//  Created by Humberto Vieira de Castro on 7/3/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit

class QuadrosViewController: UIViewController {
    var arrayQuadros:Array<Int> = [0,0,0,0,0,0,0,0]
    
    @IBOutlet var arrayButton: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eventClickEnviaDados(sender: AnyObject) {
        var binarios:String = ""
        
        for a in arrayQuadros {
            binarios = binarios + String(a)
        }
        
        DispositivosTableViewController.writeValue(binarios)
    }
    
    @IBAction func clickBotao(sender: UIButton) {
        var index: Int = 0
        
        index = find(arrayButton, sender)!
        
        arrayQuadros[index] = arrayQuadros[index] == 0 ? 1 : 0
        
        let btn = arrayButton[index]
        
        println(arrayQuadros)
        
    }
    @IBAction func blabla(sender: AnyObject) {
            print("alsldaf")

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

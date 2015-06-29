//
//  DispositivosTableViewController.swift
//  Projeto-Ferias-Quadro-Fotos-Iluminado-iOS
//
//  Created by Humberto Vieira de Castro on 6/28/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import CoreBluetooth


var activeCentralManager: CBCentralManager? // O que está controlando o Bluetooth
var peripheralDevice: CBPeripheral? // Dispositivo que será conectado pelo Bluetooth
var devices: Dictionary<String, CBPeripheral> = [:] // Lista de todos os devices que estão proximos
var deviceName: String? //Nome do Device
var devicesRSSI = [NSNumber]() //Código do Device que será conectado
var devicesServices: CBService! // Servicos do que o dispositivo vai fazer ao se conectar com o celular
var deviceCharacteristics: CBCharacteristic! //Guarda informações importantes sobre o device que será conectado

// é Importados todos os delegates para serem colocados na tableView
class DispositivosTableViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //Acontece quando a tela ainda não carregou os elementos
    override func viewDidAppear(animated: Bool) {
        // Limpa os elementos do dicionario
        devices.removeAll(keepCapacity: false)
        devicesRSSI.removeAll(keepCapacity: false)
        
        // Inicializa o Manager/Dispositivo mestre (meu iphone) Bluetooth
        activeCentralManager = CBCentralManager(delegate: self, queue: nil)
        
        //Inicia a tableView com conteudo limpo
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    
    // Atualizador
    func update(){
        // Limpa todos os elementos do dicionario
        devices.removeAll(keepCapacity: false)
        devicesRSSI.removeAll(keepCapacity: false)
        
        // Inicializa o Manager/Dispositivo metre (meu iPhone)
        activeCentralManager = CBCentralManager(delegate: self, queue: nil)
        
        //Para de atualizar
        self.refreshControl?.endRefreshing()
    }
    
    //Evento quando o estado do iPhone do Bluetooth mudar
    func centralManagerDidUpdateState(central: CBCentralManager?) {
        if let central = central{
            //Se o bluetooth estiver ligado
            if central.state == CBCentralManagerState.PoweredOn {
                // Escaneia todos os dispositivos que ele pode alcançar
                central.scanForPeripheralsWithServices(nil, options: nil)
                println("Searching for BLE Devices")
            }
            // Se o bluetooth estiver desligado
            else {
                // Can have different conditions for all states if needed - print generic message for now
                println("Bluetooth switched off or not initialized")
            }
        }
        
    }
    
    // Procura dispositivos e coloca na lista
    func centralManager(central: CBCentralManager?, didDiscoverPeripheral peripheral: CBPeripheral?, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        // Verifica se o dispositivo é nulo
        if let central = central {
            // Verifica se o dispositivo que vou me conectar é nulo
            if let peripheral = peripheral {
                //Pego o UUID do dispositivo que vou me conectar
                if let name = peripheral.name {
                    // Preenche o dicionario atraves do UUID como indice, com o dado do periferico(BLE)
                    if(devices[name] == nil){
                        devices[name] = peripheral
                        devicesRSSI.append(RSSI) // Adiciona na lista da tableview
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    // Descobre os tipos de servicos do dispositivo que vou me conectar (BLE Arduino)
    func centralManager(central: CBCentralManager?, didConnectPeripheral peripheral: CBPeripheral?) {
        // Verifica se o dispositivo é nulo
        if let central = central{
            //Verifica se o dispositivo que vou me conectar é nulo
            if let peripheral = peripheral{
                // Descobre os servicos deste dispositivo
                if let peripheralDevice = peripheralDevice{
                    peripheralDevice.discoverServices(nil)
                    // Muda o texto da navigation Controller
                    if let navigationController = navigationController{
                        navigationItem.title = "Connected to \(deviceName)"
                    }
                }
            }
        }
        
    }
    
    // Método sobrecarregado de periféricos
    func peripheral(peripheral: CBPeripheral?, didDiscoverServices error: NSError!) {
        
        if let peripheral = peripheral{
            // Itera no vetor de servicos de um dispositivo especifico
            for service in peripheral.services {
                let thisService = service as? CBService
                
                // Mostra a caracteristicas de cada servico
                if let thisService = thisService{
                    peripheral.discoverCharacteristics(nil, forService: thisService)
                    if let navigationController = navigationController{
                        navigationItem.title = "Discovered Service for \(deviceName)"
                    }
                }
            }
        }
        
    }
    
    // Método sobrecarregado
    func peripheral(peripheral: CBPeripheral?, didDiscoverCharacteristicsForService service: CBService?, error: NSError?) {
        
        //Verifica se o periférico é nulo
        if let peripheral = peripheral{
            // Verifica se os servicos deste periferico sao nulos
            if let service = service{
                // Verifica o UUID e cada caracteristica dos servicos
                // check the uuid of each characteristic to find config and data characteristics
                for charateristic in service.characteristics {
                    let thisCharacteristic = charateristic as! CBCharacteristic
                    // Notifica se tem tem alguma caracteristica nova
                    peripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
                    
                    //Muda o titulo da navBar
                    if let navigationController = navigationController{
                        navigationItem.title = "Discovered Characteristic for \(deviceName)"
                    }
                    deviceCharacteristics = thisCharacteristic
                }
                
                //Retorna pra view principal
                if let navigationController = navigationController{
                    navigationController.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    // Quando é recebido algo do Device - Retorno
    func peripheral(peripheral: CBPeripheral?, didUpdateValueForCharacteristic characteristic: CBCharacteristic?, error: NSError!) {
        println("Funcionou - Retorno com sucesso!")
    }
    
    //Cancela a conexao
    func cancelConnection(){
        if let activeCentralManager = activeCentralManager{
            println("Died!")
            if let peripheralDevice = peripheralDevice{
                //println(peripheralDevice)
                activeCentralManager.cancelPeripheralConnection(peripheralDevice)
            }
        }
    }
    
    // Se desconectar comeca a procurar mais uma vez
    func centralManager(central: CBCentralManager?, didDisconnectPeripheral peripheral: CBPeripheral?, error: NSError?) {
        if let central = central{
            if let peripheral = peripheral{
                println("Disconnected")
                central.scanForPeripheralsWithServices(nil, options: nil)
            }
        }
    }
    
    //Escreve um valor novo no BLe
    func writeValue(data: String){
        
        let data = (data as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        print("Escreve no arduino1")
        if let peripheralDevice = peripheralDevice{
            print("Escreve no arduino3")
            if let deviceCharacteristics = deviceCharacteristics {
                
                //Pega a String e manda para o arduino
                peripheralDevice.writeValue(data!, forCharacteristic: deviceCharacteristics, type: CBCharacteristicWriteType.WithResponse)
                print("Escreve no arduino")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return devices.count
    }
    


    //Preenche a tableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Pega a celula
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        // Coloca os valores do dicionario (devices) em uma variavel
        let discoveredPeripheralArray = devices.values.array
  
        
        // Verifica se a celula é nula
        if let cell = cell{
            //Procura no vetor de valores de devices o nome dos devices
            if let name = discoveredPeripheralArray[indexPath.row].name{
                
                //Altera o texto da label de cada célula
                if let textLabelText = cell.textLabel {
                    textLabelText.text = name
                }
                
                //Altera a label de detalhe tambem
                if let detailTextLabel = cell.detailTextLabel{
                    detailTextLabel.text = devicesRSSI[indexPath.row].stringValue
                }
            }
        }
        return cell!
    }
    
    // Evento de toda vez que clicarem em uma célula
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Se estiver pelo menos um dispositvo no vetor (proximo do raio do iPhone)
        if (devices.count > 0){
            
            // Coloca os valores do dicionario em um array
            let discoveredPeripheralArray = devices.values.array
            
            // Pega o valor correspondente do clique no vetor de dispositivos
            peripheralDevice = discoveredPeripheralArray[indexPath.row]
            
            // Delega o disposivo conectado na classe (conecta do dispositivo)
            if let peripheralDevice = peripheralDevice{
                peripheralDevice.delegate = self
                deviceName = peripheralDevice.name!
            }
            else
            {
                deviceName = " "
            }
            
            // Verifica se o dispositivo local é nulo
            if let activeCentralManager = activeCentralManager{
                // Para de procurar outros dispositivos
                activeCentralManager.stopScan()
                
                // Conecta a este dispositvo o clicado anteriormente
                activeCentralManager.connectPeripheral(peripheralDevice, options: nil)
                if let navigationController = navigationController{
                    navigationItem.title = "Connecting \(deviceName)"
                }
            }
            
            
            
        }
    }

    @IBAction func clickEnviaDados(sender: AnyObject) {
        println("Ta enviando")
        writeValue("c")
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

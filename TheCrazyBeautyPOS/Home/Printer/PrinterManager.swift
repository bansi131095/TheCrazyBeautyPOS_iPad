//
//  PrinterManager.swift
//  TheCrazyBeautyPOS
//
//  Created by Xceptive iOS on 23/09/25.
//

import UIKit
import CoreBluetooth


class PrinterManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = PrinterManager()
    
    private var centralManager: CBCentralManager!
    private var printerPeripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    
    var isConnected = false
    var onConnect: (() -> Void)?
    var onFail: (() -> Void)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Start scanning for paired printers
    func startScan() {
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is ON")
            startScan()
        default:
            print("Bluetooth not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("Discovered: \(peripheral.name ?? "Unknown")")
        
        // TODO: Replace "MUNBYN" with your printer name or MAC filter
        if let name = peripheral.name, name.contains("MUNBYN") {
            self.printerPeripheral = peripheral
            self.centralManager.connect(peripheral, options: nil)
            stopScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Printer")")
        isConnected = true
        printerPeripheral?.delegate = self
        peripheral.discoverServices(nil)
        onConnect?()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect: \(error?.localizedDescription ?? "")")
        isConnected = false
        onFail?()
    }
    
    // Discover services & characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for char in characteristics {
            if char.properties.contains(.writeWithoutResponse) || char.properties.contains(.write) {
                writeCharacteristic = char
                print("Write characteristic found ✅")
            }
        }
    }
    
    // MARK: - Print & Drawer
    func sendData(_ data: Data) {
        guard let peripheral = printerPeripheral,
              let characteristic = writeCharacteristic else { return }
        
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func printText(_ text: String) {
        if let data = text.data(using: .utf8) {
            sendData(data)
        }
    }
    
    func openCashDrawer() {
        let openDrawerCommand: [UInt8] = [0x1B, 0x70, 0x00, 0x32, 0xC8] // same as Android
        sendData(Data(openDrawerCommand))
    }
}


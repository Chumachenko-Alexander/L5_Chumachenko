//
//  main.swift
//  L5_Chumachenko
//
//  Created by Александр Чумаченко on 17.03.2021.
//

import Foundation

typealias km = UInt
enum WindowState {
    case open, close
}

//MARK: - протокол авто

protocol CarProtocol: class {
    ///Марка авто
    var make: String { get }
    ///Модель авто
    var model: String { get }
    ///Мощность
    var horsePower: UInt { get set }
    ///Окно открыто/ закрыто
    var window: WindowState { get set }
    ///Пробег
    var odometer: km { get set }
    
    func changeOdo(km: UInt)
    func openWindow()
    func closeWindow()
}

//MARK: - расширение CarProtocol

extension CarProtocol {
    func changeOdo(km: UInt) {
        if km > odometer {
            odometer = km
            print("Зафиксирован новый пробег на одометре - \(km) км")
        } else {
            print("Ты правда пытаешься скрутить пробег?")
            sleep(2)
            print("Увы, но мы против скручивания пробегов =(")
        }
    }
}

extension CarProtocol {
    func openWindow() {
        window = .open
        print("Окна открыты")
    }
}

extension CarProtocol {
    func closeWindow() {
        window = .close
        print("Окна закрыты")
    }
}

//MARK: - Создание классов и имплементация в них CarProtocol

class SportCar: CarProtocol {
    
    enum Transmission: String {
        case manual = "Механика"
        case automatic = "Автомат"
        case robot = "Роботизированная кпп"
        case variator = "Вариатор"
    }
    
    let make: String
    let model: String
    var horsePower: UInt
    var window: WindowState
    var odometer: km
    ///Тип трансмиссии
    var transmissionType: Transmission
    
    init(make: String, model: String, power: UInt, odometer: km, transmissionType: Transmission) {
        self.make = make
        self.model = model
        horsePower = power
        self.odometer = odometer
        window = .close
        self.transmissionType = transmissionType
    }
    
    func changeTransmissionType(newTransmissionType to: Transmission) {
        if transmissionType == to {
            print("Данный тип кпп уже установлен")
        } else {
            transmissionType = to
            print("Установлена новая трансмиссия: \(transmissionType.rawValue)")
        }
    }
}

class TunkCar: CarProtocol {
    let make: String
    let model: String
    var horsePower: UInt
    var window: WindowState
    var odometer: km
    ///Максимальная грузоподъемность (литры)
    let tunkOverVolume: Double
    ///текущая загруженность (литры)
    var tunkVolume: Double
    
    init(make: String, model: String, power: UInt, odometer: km, tunkOverVolume: Double) {
        self.make = make
        self.model = model
        horsePower = power
        self.odometer = odometer
        window = .close
        self.tunkOverVolume = tunkOverVolume
        tunkVolume = 0
    }
    
    func putInTunk (liter: Double) {
        if self.tunkVolume + liter <= self.tunkOverVolume {
            self.tunkVolume += liter
            print("Залили \(liter) литров")
        } else {
            print("В багажнике твоего \(make) \(model) не может быть больше \(tunkOverVolume) литров.,\nЗальем только то, что влезет - \(tunkOverVolume) литров.")
            tunkVolume = tunkOverVolume
        }
    }
    
    func removeFromTunk (liter: Double) {
        if self.tunkVolume - liter >= 0 {
            self.tunkVolume -= liter
            print("Слили \(liter) литров")
        } else {
            print("Ты не можешь слить из багажника больше, чем там сейчас есть.\nТак что я слил всё что было.")
            tunkVolume = 0
        }
    }
}

//MARK: - Для каждого класса написать расширение, имплементирующее протокол «CustomStringConvertible».

extension SportCar: CustomStringConvertible {
    var description: String {
        return """
---------------------
Марка, модель: \(make) \(model)
Мощность: \(horsePower) л.с.
Тип кпп - \(transmissionType.rawValue)
Пробег - \(odometer) км.
---------------------
"""
    }
}

extension TunkCar: CustomStringConvertible {
    var description: String {
        return """
---------------------
Марка, модель: \(make) \(model)
Мощность: \(horsePower) л.с.
Объем багажника: \(tunkVolume)/\(tunkOverVolume) л.
Пробег - \(odometer) км.
---------------------
"""
    }
}

//MARK: - Создать несколько объектов каждого класса. Применить к ним различные действия.

var mySportCar = SportCar(make: "Porsche", model: "911 GT-3", power: 425, odometer: 1246, transmissionType: .manual)
var myTunkCar = TunkCar(make: "Toyora", model: "Tundra", power: 160, odometer: 96000, tunkOverVolume: 1600)

print(myTunkCar)
myTunkCar.putInTunk(liter: 1700)
myTunkCar.removeFromTunk(liter: 500)
myTunkCar.changeOdo(km: 96567)
myTunkCar.openWindow()
print(myTunkCar)

print(mySportCar)
mySportCar.changeTransmissionType(newTransmissionType: .robot)
mySportCar.openWindow()
mySportCar.closeWindow()
mySportCar.changeOdo(km: 1000)
print(mySportCar)

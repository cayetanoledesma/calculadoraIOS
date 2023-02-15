//
//  ViewController.swift
//  calculadora
//

//

import UIKit

class ViewController: UIViewController {

    
    //resultado
    @IBOutlet weak var resultLabel: UILabel!
    
    
    //números
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    //operadores
    
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMInus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    //Variables
    
    private var total: Double = 0                   //indica el valor total
    private var temp: Double = 0                    // indica el valor por pantalla
    private var operating = false                   // indica si se ha seleccionado un operador
    private var decimal = false                     // indica si el valor es decimal
    private var operation: OperationType = .none    // operación actual
    
    //Constantes
    
    private let KDecimalSeparator = Locale.current.decimalSeparator!
    private let KMaxLenght = 9
    private let KMaxValue: Double = 999999999
    private let KMinValue: Double = 0.00000001
    
    
    
    private enum OperationType {
        case none, addiction, substraction, multiplication, division, percent
    }
    
    //formateamos valores auxiliares
    
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    // Formateamos los valores por pantalla por defecto
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorAC.round()
        operatorPlusMInus.round()
        operatorPercent.round()
        operatorResult.round()
        operatorAddition.round()
        operatorSubstraction.round()
        operatorMultiplication.round()
        operatorDivision.round()
        
        numberDecimal.setTitle(KDecimalSeparator, for: .normal)
        result()
        
       
    }

    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    
    @IBAction func operatorPlusMInus(_ sender: UIButton) {
        temp = temp * (-1)

        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        sender.shine()
    }
    
    @IBAction func operatorPercent(_ sender: UIButton) {
        
        if operation != .percent {
            result()
        }
        operating = true
        operation = .percent
        result()
        sender.shine()
    }
    
    @IBAction func operatorResultAction(_ sender: UIButton) {
        
        result()
        sender.shine()
    }
    
    
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        operating = true
        operation = .addiction
        
        sender.shine()
    }
    
    
    
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        operating = true
        operation = .substraction
        sender.shine()
    }
    
    
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        operating = true
        operation = .multiplication
        sender.shine()
    }
    
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        
        if operation != .none {
            result()
        }
        operating = true
        operation = .division
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        // lo primero es tener un valor asociado a lo que vemos por pantalla
        let currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        //lo siguiente es saber si estamos haciendo alguna operación
        if !operating && currentTemp.count >= KMaxLenght {
            return
        }
        
        resultLabel.text = resultLabel.text! + KDecimalSeparator
        decimal = true
        sender.shine()
    }
    
    
    // esta es la funcion que contiene todos los números que estan etiquetados "tag"
    @IBAction func numberAction(_ sender: UIButton) {
        
        operatorAC.setTitle("C", for: .normal)
         // comprobamos que esta operando y que la longitud no supera los 9 dígito máximo
        var currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= KMaxLenght {
            return
        }
        
        //Ahora seleccionamos una operación
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
            
        }
        
        // otra posibilidad es cuando estamos usando valores decimales y hay que comprobarlo
        
        if decimal {
            currentTemp = "\(currentTemp)\(KDecimalSeparator)"
            decimal = false
        }
        //En esta variable tendremos el valor del número pulsado
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
        
    }
    
    //Esta funcion limpia los valores
    private func clear() {
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultLabel.text = "0"
        }else {
            total = 0
            result()
        }
    }
    
    //Obtenemos el resultado final
    private func result() {
        
        switch operation  {
            
        case .none:
            // No hacemos nada en este bloque
            break
        case .addiction:
            total = total + temp
            break
        case .substraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
        // Formateo por pantalla, es decir, la comprobación que debemos hacer una vez sepamos el total
        if total <= KMaxValue || total >= KMinValue {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        print("TOTAL: \(total)")
        
    }
    
    
}


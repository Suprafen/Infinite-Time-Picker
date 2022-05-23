//
//  ViewController.swift
//  Infinite-Time-Picker
//
//  Created by Ivan Pryhara on 23.05.22.
//

import UIKit

protocol TimeGoalSettingsDelegate {
    func getTime(_ time: Int)
}

class TimeGoalSettingsViewController: UIViewController {

    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 15
        
        return stack
    }()
    
    let labelsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 15
        
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.text = "Set Time Goal"
        label.contentHuggingPriority(for: .vertical)
        
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.numberOfLines = 2
        label.textColor = .systemGray2
        label.text = "Set time goal and let's start!"
        label.contentHuggingPriority(for: .vertical)
        
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 200))
        textField.borderStyle = .none
        textField.text = "00:00"
        textField.tintColor = .black
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        textField.keyboardType = .numberPad
        textField.addTarget(nil, action: #selector(timeGoalTextFieldChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    let timePicker: UIPickerView = {
        let timePicker = UIPickerView()
        return timePicker
    }()
    
    var delegate: TimeGoalSettingsDelegate?
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
    //MARK: Helper methods
    func configureView() {
        self.view.backgroundColor = .white
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        
        self.timePicker.selectRow(self.minutes, inComponent: 0, animated: true)
        self.timePicker.selectRow(self.seconds, inComponent: 1, animated: true)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timePicker)

        self.view.addSubview(stackView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func retrieveTime(_ time: Int) {
        delegate?.getTime(time)
    }
    
    //MARK: Selectors
    
    @objc func timeGoalTextFieldChanged(_ sender: UITextField) {
        guard var textFieldString = sender.text else { return }
        let letterToTheBack = textFieldString[textFieldString.startIndex]
        if textFieldString.count < 5 {
            textFieldString.remove(at: textFieldString.startIndex)
            textFieldString.insert(contentsOf: [letterToTheBack], at: textFieldString.endIndex)
        } else {
            textFieldString.removeLast()
        }
        sender.text = textFieldString
    }
}

extension TimeGoalSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0,1,2:
            return 10000
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row%24) hours"
        case 1:
            return "\(row%60) min"
        case 2:
            return "\(row%60) sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO: Add a case where hours, seconds and minutes can be 0.
        // Just for making this clear. If one of three components has a value
        // two others can be 0
        
        switch component {
        case 0:
            if row == 0 || row%24 == 0 {
                pickerView.selectRow(row + 1, inComponent: 0, animated: true)
                hours = 1
            } else {
                hours = row%24
                print("Hours: \(hours)")
            }
            
        case 1:
            if row == 0 || row%60 == 0 && (hours == 0 && seconds == 0) {
                pickerView.selectRow(row + 1, inComponent: 1, animated: true)
                minutes = 1
            } else if (hours > 0 || seconds > 0 ) && (row == 0 || row%60 == 0) {
//                pickerView.selectRow(row, inComponent: 1, animated: true)
                minutes = 0
            }
            else {
                minutes = row%60
                print("Hours: \(minutes)")
            }
            
        case 2:
            if row == 0 || row%60 == 0 {
                pickerView.selectRow(row + 1, inComponent: 2, animated: true)
                seconds = 1
            } else {
                seconds = row%60
                print("Hours: \(seconds)")
            }
        default:
            break
        }
        retrieveTime(((hours*60*60) + (minutes * 60)) + seconds)
//        print("Seconds \(((hours*60*60) + (minutes * 60)) + seconds)")
        print("""
    Hours \(hours)
    Minutes \(minutes)
    Seconds \(seconds)
___
""")
    }
}

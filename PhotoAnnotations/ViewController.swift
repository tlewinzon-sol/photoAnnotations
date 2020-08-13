//
//  ViewController.swift
//  DrawOnImages
//
//  Created by Tobias Lewinzon on 16/07/2020.
//  Copyright © 2020 tobiaslewinzon. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    // MARK: - Global properties
    let canvas = Canvas()
    let image = UIImage(named: "corn")
    
    // MARK: - View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        addCanvasView()
        addControls()
        addTapGesture()
    }
    
    // MARK: - View configuration
    private func addCanvasView() {
        // Setup canvas.
        view.addSubview(canvas)
        canvas.backgroundColor = .clear
        canvas.frame = view.frame
    }
    
    private func addBackgroundImage() {
        // Adding a UIImage covering the whole frame to simulate the possible feature of making annotations over a fieldNote photo.
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
    }
    
    /// Adds tap gesture recognizer to exit textField editing.
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Adds all controls on screen.
    private func addControls() {
        
        // Undo button.
        let undoButton = UIButton(type: .system)
        undoButton.setTitle("Undo", for: .normal)
        undoButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        undoButton.titleLabel?.textColor = .white
        undoButton.tintColor = .white
        undoButton.backgroundColor = .darkGray
        undoButton.layer.cornerRadius = 12
        undoButton.clipsToBounds = true
        undoButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        // Clear button.
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        clearButton.titleLabel?.textColor = .white
        clearButton.tintColor = .white
        clearButton.backgroundColor = .darkGray
        clearButton.layer.cornerRadius = 12
        clearButton.clipsToBounds = true
        clearButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        // Red color button.
        let color1Button = UIButton(type: .system)
        color1Button.backgroundColor = .red
        color1Button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        
        // White color button.
        let color2Button = UIButton(type: .system)
        color2Button.backgroundColor = .white
        color2Button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        
        // Black color button.
        let color3Button = UIButton(type: .system)
        color3Button.backgroundColor = .black
        color3Button.addTarget(self, action: #selector(changeStrokeColor), for: .touchUpInside)
        
        // Save button.
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        saveButton.titleLabel?.textColor = .white
        saveButton.tintColor = .white
        saveButton.backgroundColor = .darkGray
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        
        // Text button.
        let addTextButton = UIButton(type: .system)
        addTextButton.setTitle("[ t ]", for: .normal)
        addTextButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        addTextButton.titleLabel?.textColor = .white
        addTextButton.tintColor = .white
        addTextButton.backgroundColor = .darkGray
        addTextButton.addTarget(self, action: #selector(addText), for: .touchUpInside)
        addTextButton.layer.cornerRadius = 12
        addTextButton.clipsToBounds = true
        
        // Stack view containing undo, clear and color buttons.
        let stack = UIStackView(arrangedSubviews: [undoButton, color1Button, color2Button, color3Button ,clearButton])
        stack.distribution = .fillEqually
        
        // Stack view constraints.
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        // Save button constraints.
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        // Text button constraints.
        view.addSubview(addTextButton)
        addTextButton.translatesAutoresizingMaskIntoConstraints = false
        addTextButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addTextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addTextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        addTextButton.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -20).isActive = true
    }
    
    /// Removes all elements intended to be excluded from saved image.
    private func removeControls() {
        for view in view.subviews {
            if let stack = view as? UIStackView {
                stack.removeFromSuperview()
            } else if let button = view as? UIButton {
                button.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Action methods
    @objc func undo() {
        canvas.undo()
    }
    
    @objc func clear() {
        canvas.clear()
    }
    
    @objc func changeStrokeColor(button: UIButton) {
        canvas.changeColor(to: button.backgroundColor ?? .white)
    }
    
    @objc func save() {
        // Prepare view.
        removeControls()
        
        // Generate snapshot.
        let image = UIImage(view: self.view)
        
        // Saving to check image is edited correctly.
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        // Restore view.
        addControls()
    }
    
    /// Adds a new textField centered on the view.
    @objc func addText() {
        
        canvas.isHandlingLabel = true
    
        // Create label centered on screen.
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textField.center = canvas.center
        
        textField.text = "Tap to edit. Pinch to scale and rotate."
        
        addGestureRecognizers(to: textField)
        
        view.addSubview(textField)
    }
    
    /// Resigns first responder on any textField.
    @objc func handleTap() {
        for view in view.subviews {
            guard let textField = view as? UITextField else { continue }
            textField.resignFirstResponder()
        }
    }
}

// MARK: - Gestures
extension ViewController {
    
    func addGestureRecognizers(to textField: UITextField) {
        // Create UIGestureRecognizers and setup delegate.
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        
        pinchGesture.delegate = self
        panGesture.delegate = self
        rotateGesture.delegate = self
        
        // Adding them to passed view.
        textField.addGestureRecognizer(pinchGesture)
        textField.addGestureRecognizer(panGesture)
        textField.addGestureRecognizer(rotateGesture)
        
        // Setup textField
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = true
        textField.delegate = self
        textField.textColor = .white
        textField.backgroundColor = .black
        
        // User is mow handling a textField
        canvas.isHandlingLabel = true
    }
    
    /// Called when pinch is detected.
    /// - Parameter gesture: Contains an instance of the view affected by the gesture to apply needed transformations.
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        // Guard view.
        guard let gestureView = gesture.view else { return }
        
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale,
                                                               y: gesture.scale)
        // Set to default.
        gesture.scale = 1
    }
    
    /// Called when pan is detected.
    /// - Parameter gesture: Contains an instance of the view affected by the gesture to apply needed transformations.
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        // Amount of movement.
        let translation = gesture.translation(in: view)
        
        // Get the view the gesture is manifested in and make changes to it. This is nice since we do not need an instance of the view, it comes with this gesture parameter.
        guard let gestureView = gesture.view else { return }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                     y: gestureView.center.y + translation.y)
        
        // Ensure translations don't add up every time. Set to default.
        gesture.setTranslation(.zero, in: view)
    }
    
    /// Called when rotate is detected.
    /// - Parameter gesture: Contains an instance of the view affected by the gesture to apply needed transformations.
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
         // Guard view.
           guard let gestureView = gesture.view else {
             return
           }

           gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
           
           // Set to default.
           gesture.rotation = 0
    }
}

// MARK: - UIGestureRecognizerDelegate.

extension ViewController: UIGestureRecognizerDelegate {
    // Allows multiple gestures on a single view.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextFieldDelegate {
    
    /// Runs when user taps on textField to edit.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // To avoid textFields hidden below the keyboard, force them on the center when edited.
        textField.center = view.center
    }
    
    /// Runs every time a change is made on the textField text.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Adjust size every time.
        textField.sizeToFit()
    }
}

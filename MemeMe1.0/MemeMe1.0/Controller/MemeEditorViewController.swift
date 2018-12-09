//
//  ViewController.swift
// MemeMe1.0
//
//  Created by Nora al-mansour on 3/6/1440 AH.
//  Copyright © 1440 Nora al-mansour. All rights reserved.


// MARK: I just copyit from my "MemeMe 1.0" project :)   ******** 

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITextFieldDelegate{

//.................
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField2: UITextField!

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var sharBtn: UIBarButtonItem!

    var memedImage: UIImage!
 //..............

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the defaultTextAttributes property:

        //MARK.UPDATING::..............
        setTextStyle(txtField1, string: "TOP")
        setTextStyle(txtField2, string: "BOTTOM")
    
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        // Check if Camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        //KeyBoard
            subscribeToKeyboardNotifications()
        //sharing Btn:
        sharBtn.isEnabled = imagePickerView.image != nil
     }

   override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
    //KeyBoard
            unsubscribeFromKeyboardNotifications()

      }
 //**************.......... MARK::KeyBoard-Start ....................
// Addining notified when the keyboard appears
            func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

             NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }

//Removing notified when the keyboard appears
        func unsubscribeFromKeyboardNotifications() {
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
          }

    //When the keyboardWillShow notification is received, shift the view's frame up
    @objc func keyboardWillShow(_ notification:Notification) {
        if txtField2.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)}
    }
    // Implementing "keyboardWillHide":
  @objc func keyboardWillHide(_ notification:Notification){
            view.frame.origin.y = 0 }

// Keyboard Height
            func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.cgRectValue.height
            }
//**************........... KeyBoard-END............. ..........


     //Function that allows the user to use the return key to escape from the text input
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: UPDATING :: 2nd review
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated:true, completion:nil)
    }

    // MARK. UPDATING:: Lunching Album:
    @IBAction func pickImg(_ sender: Any) {
//        let pikerController = UIImagePickerController()
//        pikerController.delegate = self
//        pikerController.sourceType = .photoLibrary
//        present(pikerController, animated: true, completion: nil)
        presentImagePickerWith(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }



    //2.MARK:: UIImagePickerController Delegate, (https://developer.apple.com/documentation/uikituiimagepickercontrollerdelegate)

    //2-A)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            // Getting Selected Img.:
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                //Setting imagePickerView = Selected Img:
                imagePickerView.image = image
            }
            picker.dismiss(animated: true)
        }
        print(info)
    }
    //2-B)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        print("Canceled By User")
    }
    //...............***********

    //3.MARK::Lunching Camera UPDATING
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("camera not supported")
            return
        }
         presentImagePickerWith(sourceType: UIImagePickerControllerSourceType.camera)
    }

    //4.MARK:: DefaultTextAttributes property
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue:UIColor.white ,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0]

    // MARK.UPDATING::.......Func basded on reviewr comment to solve the issues of styel
    func setTextStyle (_ textField: UITextField, string : String){
        textField.delegate = self
        textField.text = string
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.autocapitalizationType = .allCharacters
    }
    // MARK::To-Do from Udacity ::

    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
        toolBar.isHidden = true
        navBar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        toolBar.isHidden = false
        navBar.isHidden = false

        return memedImage
    }

    func save() {
        // Create the MemeObject::
       // let memedImage = generateMemedImage()
        var meme = MemeObject(topText: txtField1.text!, bottomText: txtField2.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())

        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        //(UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }

    @IBAction func sharBtn(_ sender: Any) {
        let memeToShare = generateMemedImage()

        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                //Save the image
                self.save()
                ///Dismiss the view controller
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController , animated: true , completion: nil)
    }
    
    // MARK :: Updating
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

  }




//
//  ViewController.swift
//  AnhLe-Lab3
//
//  Created by Anh Le on 10/23/20.
//  Copyright © 2020 Anh Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentLine: Line?
    var lineCanvas: LineView!
    var currentColor = UIColor.red
    var thickness = CGFloat(25)
    @IBOutlet weak var slider: UISlider!
    //Coloring Image
    @IBOutlet weak var ColoringImage: UIImageView!
    //Drawing Space
    @IBOutlet weak var drawingView: UIView!
    
    var colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, UIColor(red: 0.9686, green: 0.5882, blue: 0.9686, alpha: 1.0)]
    let coloringPictures = [UIImage(named: "duck"),
                            UIImage(named: "cat"),
                            UIImage(named: "pig"),
                            UIImage(named: "flower")]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lineCanvas = LineView(frame: CGRect(x: 0, y: 0, width: drawingView.frame.width, height: drawingView.frame.height))
        drawingView.addSubview(lineCanvas)
    }
    
    // slider to change the thickness of the line
    @IBAction func thicknessSlider(_ sender: UISlider) {
        thickness = CGFloat(slider.value)
        currentLine?.width = thickness
    }
    
    // button to clear the content of the screen
    @IBAction func clearScreen(_ sender: Any) {
        ColoringImage.image = nil
        lineCanvas.theLine = nil
        lineCanvas.lines = []
    }
    
    // button to undo the last line
    @IBAction func undoLine(_ sender: Any) {
        if(!lineCanvas.lines.isEmpty){
            lineCanvas.theLine = nil
            lineCanvas.lines.removeLast()
        }
    }
    
    // Select coloring pictures
    @IBAction func coloringPic(_ sender: UIButton) {
        if(sender.tag == 4){
            ColoringImage.image = nil
        }
        else{
            ColoringImage.image = coloringPictures[sender.tag]
        }
    }
    
    
    // button to change color of the line
    @IBAction func changeColor(_ sender: UIButton) {
        currentColor = colors[sender.tag]
    }
    
    // button to save the drawing
    @IBAction func screenshot(_ sender: Any) {
        UIGraphicsBeginImageContext(drawingView.bounds.size)
        drawingView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved Successful", message: "Your drawing is saved to the Photos App", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: drawingView) else { return }
        currentLine = Line(points: [touchPoint], width: thickness, color: currentColor)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: drawingView) else { return }
        currentLine?.points.append(touchPoint)
        lineCanvas.theLine = currentLine
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: drawingView) else { return }
        currentLine?.points.append(touchPoint)
        lineCanvas.theLine = currentLine
        if let newLine = currentLine{
            lineCanvas.lines.append(newLine)
        }
        currentLine = nil
    }

}


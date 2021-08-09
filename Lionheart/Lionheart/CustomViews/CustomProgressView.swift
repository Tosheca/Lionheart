//
//  CustomProgressView.swift
//  Lionheart
//
//  Created by Teodor Pavlov on 9.08.21.
//

import Foundation
import UIKit

class CustomProgressView: UIView {
    
    // Color properties available for change outside the view
    public var backgroundCircleColor: UIColor = UIColor.lightGray
    public var foregroundCircleColor: UIColor = UIColor.red
    public var startGradientColor: UIColor = UIColor.red
    public var endGradientColor: UIColor = UIColor.yellow
    public var fillColor: UIColor = UIColor.clear
    
    private var backgroundLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    
    public var progress: CGFloat = 0 {
        didSet {
            didUpdateProgress()
        }
    }
    
    private var timer: Timer?
    public var duration: TimeInterval = 3.0
    public var lineWidth: CGFloat = 0.1
    
    override func draw(_ rect: CGRect) {
        
        guard layer.sublayers == nil else {
            return
        }
        
        let lineWidth = min(frame.size.width, frame.size.height) * lineWidth
        
        backgroundLayer = createCircularLayer(strokeColor: backgroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
        
        progressLayer = createCircularLayer(strokeColor: foregroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
        progressLayer.strokeEnd = progress
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradientLayer.colors = [startGradientColor.cgColor, endGradientColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.mask = progressLayer
                
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
    }
    
    // Creates circular layer based in the view size
    private func createCircularLayer(strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let width = frame.size.width
        let height = frame.size.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = fillColor
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    private func didUpdateProgress() {
        progressLayer?.strokeEnd = progress
    }
}

// MARK: Animations
extension CustomProgressView {
    
    func startAnimation() {
        //reseting progress
        self.progress = 0
        self.timer?.invalidate()
        
        // constructs Timer to animate the fill
        timer = Timer.scheduledTimer(withTimeInterval: duration*0.1, repeats: true, block: { timer in
            
            DispatchQueue.main.async {
                self.progress += 0.1
                
                if self.progress == 1.0 {
                    timer.invalidate()
                }
            }
        })
        timer?.fire()
    }
    
    func stopAnimation(completion: @escaping(() -> Void)) {
        timer?.invalidate() // resets timer
        
        // constructs Timer to animate the fill to the end
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { timer in
            
            DispatchQueue.main.async {
                self.progress += (1.0 - self.progress)
                timer.invalidate()
                completion()
            }
        })
        timer?.fire()
    }
}

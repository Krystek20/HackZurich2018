import UIKit

class HMKDashboardView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let theBrightest = UIBezierPath()
        theBrightest.move(to: .zero)
        theBrightest.addLine(to: CGPoint(x: 0, y: bounds.height))
        theBrightest.addCurve(to: CGPoint(x: bounds.width, y: bounds.height * 0.95), controlPoint1: CGPoint(x: bounds.width / 2, y: bounds.height * 0.5), controlPoint2: CGPoint(x: bounds.width / 2, y: bounds.height * 1))
        theBrightest.addLine(to: CGPoint(x: bounds.width, y: 0))
        theBrightest.addLine(to: .zero)

        UIColor.theBrightest.setFill()
        theBrightest.close()
        theBrightest.fill()
        
        let brighter = UIBezierPath()
        brighter.move(to: .zero)
        brighter.addLine(to: CGPoint(x: 0, y: bounds.height * 0.75))
        brighter.addCurve(to: CGPoint(x: bounds.width, y: bounds.height * 0.85), controlPoint1: CGPoint(x: bounds.width / 2, y: bounds.height * 0.7), controlPoint2: CGPoint(x: bounds.width / 2, y: bounds.height * 1.2))
        brighter.addLine(to: CGPoint(x: bounds.width, y: 0))
        brighter.addLine(to: .zero)
        
        UIColor.theBrighter.setFill()
        brighter.close()
        brighter.fill()
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: bounds.height * 0.75))
        path.addCurve(to: CGPoint(x: bounds.width, y: bounds.height * 0.75), controlPoint1: CGPoint(x: bounds.width / 2, y: bounds.height * 1.2), controlPoint2: CGPoint(x: bounds.width / 2, y: bounds.height * 0.8))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addLine(to: .zero)

        UIColor.regular.setFill()
        path.close()
        path.fill()
    }
    
}

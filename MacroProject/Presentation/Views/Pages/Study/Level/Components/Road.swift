//
//  Road.swift
//  MacroProject
//
//  Created by Ages on 04/11/24.
//

import SwiftUI

struct Road: View {
    var body: some View {
        VStack{
            ZStack{
                Image("Road")
                Image("Road-dash")
                
            }
            
            ZStack{
                Image("Road")
                Image("Road-dash")
                
            }
            .padding(.top, 30)
            Spacer()
        }
        
    }
}
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX+50, y: rect.minY+100)) // Start of line 1
        path.addLine(to: CGPoint(x: rect.minX+50, y: rect.minY+170))
        
        path.addQuadCurve(to: CGPoint(x: rect.minX+80, y: rect.minY+210), // curve after line 1
                          control: CGPoint(x: rect.minX+50, y: rect.minY+210))
        
        path.addLine(to: CGPoint(x: rect.maxX-80, y: rect.minY+210)) // line 2
        path.addQuadCurve(to: CGPoint(x: rect.maxX-50, y: rect.minY+240), // curve after line 2
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+210))
        
        path.addLine(to: CGPoint(x: rect.maxX-50, y: rect.minY+370)) // line 3
        path.addQuadCurve(to: CGPoint(x: rect.maxX-80, y: rect.minY+430), // curve after line 3
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+430))
        
        path.addLine(to: CGPoint(x: rect.minX+80, y: rect.minY+430)) // line 4
        path.addQuadCurve(to: CGPoint(x: rect.minX+50, y: rect.minY+460), // curve after line 4
                          control: CGPoint(x: rect.minX+50, y: rect.minY+430))
        
        path.addLine(to: CGPoint(x: rect.minX+50, y: rect.minY+590)) // line 5
        path.addQuadCurve(to: CGPoint(x: rect.minX+80, y: rect.minY+650), // curve after line 5
                          control: CGPoint(x: rect.minX+50, y: rect.minY+650))
        
        path.addLine(to: CGPoint(x: rect.maxX-80, y: rect.minY+650)) // line 6
        path.addQuadCurve(to: CGPoint(x: rect.maxX-50, y: rect.minY+680), // curve after line 6
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+650))
        
        path.addLine(to: CGPoint(x: rect.maxX-50, y: rect.minY+810)) // line 7
        path.addQuadCurve(to: CGPoint(x: rect.maxX-80, y: rect.minY+870), // curve after line 7
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+870))
        
        path.addLine(to: CGPoint(x: rect.minX+80, y: rect.minY+870)) // line 8
        path.addQuadCurve(to: CGPoint(x: rect.minX+50, y: rect.minY+910), // curve after line 8
                          control: CGPoint(x: rect.minX+50, y: rect.minY+870))
        
        path.addLine(to: CGPoint(x: rect.minX+50, y: rect.minY+1030)) // line 9
        
        return path
    }
}

struct Line2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX+50, y: rect.minY+100)) // line 1
        path.addLine(to: CGPoint(x: rect.minX+50, y: rect.minY+150))
        
//        path.move(to: CGPoint(x: rect.minX+50, y: rect.minY+200))
//        path.addQuadCurve(to: CGPoint(x: rect.minX+60, y: rect.minY+210),
//                          control: CGPoint(x: rect.minX+50, y: rect.minY+210))
        
        path.move(to: CGPoint(x: rect.minX+100, y: rect.minY+210)) // line 2
        path.addLine(to: CGPoint(x: rect.maxX-110, y: rect.minY+210))
        
//        path.move(to: CGPoint(x: rect.maxX-60, y: rect.minY+210))
//        path.addQuadCurve(to: CGPoint(x: rect.maxX-50, y: rect.minY+220),
//                          control: CGPoint(x: rect.maxX-50, y: rect.minY+210))
        
        path.move(to: CGPoint(x: rect.maxX-50, y: rect.minY+270)) // line 3
        path.addLine(to: CGPoint(x: rect.maxX-50, y: rect.minY+370))
        
//        path.move(to: CGPoint(x: rect.maxX-50, y: rect.minY+420))
//        path.addQuadCurve(to: CGPoint(x: rect.maxX-60, y: rect.minY+430),
//                          control: CGPoint(x: rect.maxX-50, y: rect.minY+430))
        
        path.move(to: CGPoint(x: rect.minX+110, y: rect.minY+430)) // line 4
        path.addLine(to: CGPoint(x: rect.maxX-110, y: rect.minY+430))
        
//        path.move(to: CGPoint(x: rect.minX+60, y: rect.minY+430))
//        path.addQuadCurve(to: CGPoint(x: rect.minX+50, y: rect.minY+440),
//                          control: CGPoint(x: rect.minX+50, y: rect.minY+430))

        path.move(to: CGPoint(x: rect.minX+50, y: rect.minY+490)) // line 5
        path.addLine(to: CGPoint(x: rect.minX+50, y: rect.minY+590))
        
//        path.move(to: CGPoint(x: rect.minX+50, y: rect.minY+640))
//        path.addQuadCurve(to: CGPoint(x: rect.minX+60, y: rect.minY+650),
//                          control: CGPoint(x: rect.minX+50, y: rect.minY+650))
        
        path.move(to: CGPoint(x: rect.minX+110, y: rect.minY+650)) // line 6
        path.addLine(to: CGPoint(x: rect.maxX-110, y: rect.minY+650))
        
//        path.move(to: CGPoint(x: rect.maxX-60, y: rect.minY+650))
//        path.addQuadCurve(to: CGPoint(x: rect.maxX-50, y: rect.minY+660),
//                          control: CGPoint(x: rect.maxX-50, y: rect.minY+650))
    
        path.move(to: CGPoint(x: rect.maxX-50, y: rect.minY+710)) // line 7
        path.addLine(to: CGPoint(x: rect.maxX-50, y: rect.minY+810))
        
//        path.move(to: CGPoint(x: rect.maxX-50, y: rect.minY+860))
//        path.addQuadCurve(to: CGPoint(x: rect.maxX-60, y: rect.minY+870),
//                          control: CGPoint(x: rect.maxX-50, y: rect.minY+870))
        
        path.move(to: CGPoint(x: rect.minX+110, y: rect.minY+870)) // line 8
        path.addLine(to: CGPoint(x: rect.maxX-110, y: rect.minY+870))
        
//        path.move(to: CGPoint(x: rect.minX+60, y: rect.minY+870))
//        path.addQuadCurve(to: CGPoint(x: rect.minX+50, y: rect.minY+880),
//                          control: CGPoint(x: rect.minX+50, y: rect.minY+870))
        
        return path
    }
}

struct Corner: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX+50, y: rect.minY+180))
        path.addQuadCurve(to: CGPoint(x: rect.minX+80, y: rect.minY+210),
                          control: CGPoint(x: rect.minX+50, y: rect.minY+210))
        
        path.move(to: CGPoint(x: rect.maxX-80, y: rect.minY+210))
        path.addQuadCurve(to: CGPoint(x: rect.maxX-50, y: rect.minY+240),
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+210))
        
        path.move(to: CGPoint(x: rect.maxX-50, y: rect.minY+400))
        path.addQuadCurve(to: CGPoint(x: rect.maxX-80, y: rect.minY+430),
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+430))
        
        path.move(to: CGPoint(x: rect.minX+80, y: rect.minY+430))
        path.addQuadCurve(to: CGPoint(x: rect.minX+50, y: rect.minY+460),
                          control: CGPoint(x: rect.minX+50, y: rect.minY+430))

        
        path.move(to: CGPoint(x: rect.minX+50, y: rect.minY+610))
        path.addQuadCurve(to: CGPoint(x: rect.minX+80, y: rect.minY+650),
                          control: CGPoint(x: rect.minX+50, y: rect.minY+650))
        
        path.move(to: CGPoint(x: rect.maxX-80, y: rect.minY+650))
        path.addQuadCurve(to: CGPoint(x: rect.maxX-50, y: rect.minY+680),
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+650))
        
        path.move(to: CGPoint(x: rect.maxX-50, y: rect.minY+830))
        path.addQuadCurve(to: CGPoint(x: rect.maxX-80, y: rect.minY+870),
                          control: CGPoint(x: rect.maxX-50, y: rect.minY+870))
        
        path.move(to: CGPoint(x: rect.minX+80, y: rect.minY+870))
        path.addQuadCurve(to: CGPoint(x: rect.minX+50, y: rect.minY+910),
                          control: CGPoint(x: rect.minX+50, y: rect.minY+870))

        return path
    }
}

#Preview{
    Road()
}

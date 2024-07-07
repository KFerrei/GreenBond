//  View+Extensions.swift
//  GreenBond
//  Created by FERREIRA Kévin on 22/6/2024.
//  Modified by FERREIRA Kévin on 22/6/2024.


import SwiftUI

// MARK: View Extensions for UI Building
extension View{
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
    }
    
    func disableWithOpacity(_ condition: Bool)->some View{
        self.disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    func hAlign(_ alignment: Alignment)->some View{
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment)->some View{
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func border(_ width: CGFloat, _ color: Color)->some View{
        self.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background{
                RoundedRectangle(cornerRadius: 5, style:.continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    func fillView(_ color: Color)->some View{
        self.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background{
                RoundedRectangle(cornerRadius: 5, style:.continuous)
                    .fill(color)
            }
    }
    
    func borderFillView(_ width: CGFloat, _ colorStroke: Color, _ colorFill: Color)->some View{
        self.padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background{
                RoundedRectangle(cornerRadius: 5, style:.continuous)
                    .stroke(colorStroke, lineWidth: width)
                    .fill(colorFill)
            }
    }
}

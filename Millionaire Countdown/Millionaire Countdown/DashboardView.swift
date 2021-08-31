//
//  DashboardView.swift
//  Millionaire Countdown
//
//  Created by Matthew Smith on 23/07/2021.
//

import SwiftUI

struct DashboardView: View {
    // Variables
    
    @State public var deposits: [Point] = []
    @State public var totals: [Point] = []
    
    init() {
        self.CreatePlots()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing:10){
                
                // Dashboard Title
                Text("Dashboard")
                    .font(.system(size: 40, weight: .semibold))
                
                VStack {
                    Text("Target Countdown")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color("InputLabel"))
                    HStack{
                        Text("13 Years")
                            .font(.system(size: 25))
                            .padding(7)
                            .background(
                                RoundedRectangle(cornerRadius: 7.5)
                                    .fill(Color("TextFieldBackground"))
                            )
                        Text("4 Months")
                            .font(.system(size: 25))
                            .padding(7)
                            .background(
                                RoundedRectangle(cornerRadius: 7.5)
                                    .fill(Color("TextFieldBackground"))
                            )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .modifier(Containers())
                
                VStack {
                    
                    ZStack(){
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Investment Value").font(.system(size: 14, weight: .light)).foregroundColor(Color("InputLabel"))
                            Text("$10,300,300").font(.system(size: 28, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200, alignment: .topLeading)

                            
                        GraphView(data: totals, data2: deposits)
                            .onAppear { self.CreatePlots()}
                            .animation(Animation.easeInOut(duration: 1).delay(0.5))
                            .frame(maxHeight: 200)
                        }
                    HStack {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 4)
                            .background(Circle().foregroundColor(Color.blue))
                            .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        Text("$8,400,000")
                            .font(.system(size: 15, weight: .regular))
                            .padding(.leading, 5)
                            
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 4)
                            .background(Circle().foregroundColor(Color("Interest")))
                            .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        Text("$1,900,000")
                            .font(.system(size: 15, weight: .regular))
                            .padding(.leading, 5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .modifier(Containers())

            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    func CreatePlots() {
        for x in 1...5 {
            deposits.append(Point(x: CGFloat(x), y: CGFloat(x*2)))
            totals.append(Point(x: CGFloat(x), y: CGFloat(x*3)))
        }
    }
}


struct GraphView: View {
    
    let data: [Point]
    let data2: [Point]
    
    private var maxYValue: CGFloat {
        data.max { $0.y < $1.y }?.y ?? 0
    }
    private var maxXValue: CGFloat {
        data.max { $0.x < $1.x }?.x ?? 0
    }
    
    var body: some View {
        ZStack {
            InterestPlot
            DepositPlot
        }
    }
    
    private var InterestPlot: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: geometry.size.height))
                
                self.data.forEach { point in
                    let x = (point.x / self.maxXValue) * geometry.size.width
                    let y = geometry.size.height - (point.y / self.maxYValue) * geometry.size.height
                    path.addLine(to: .init(x: x, y: y))
                }
            }
            .stroke(
                Color("Interest"),
                style: StrokeStyle(lineWidth: 5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.7))
        }
    }
    
    private var DepositPlot: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: geometry.size.height))
                
                self.data2.forEach { point in
                    let x = (point.x / self.maxXValue) * geometry.size.width
                    let y = geometry.size.height - (point.y / self.maxYValue) * geometry.size.height
                    path.addLine(to: .init(x: x, y: y))
                }
            }
            .stroke(
                Color.blue,
                style: StrokeStyle(lineWidth: 5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.5))
        }
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .previewDevice("iPhone 11 Pro")
    }
}



//
//  CalculatorView.swift
//  Millionaire Countdown
//
//  Created by Matthew Smith on 20/07/2021.
//

import SwiftUI

struct CalculatorView: View {
    
    @State public var deposit = ""
    @State public var interest = ""
    @State public var addition = ""
    @State public var years = ""
    
    @State private var futureValue = ""
    @State private var futureInterest = ""
    @State private var futureDeposits = ""
    
    @State private var alert = false
    @State private var buildGraph = false
    
    // Chart Default Values
    @State private var chartWidth = 0.0
    @State public var data: [Point] = []
    @State public var data2: [Point] = []
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView(.vertical) {
                    VStack (alignment: .leading, spacing: 10) {
                        
                        // Calculator Title
                        Text("Calculator")
                            .font(.system(size: 40, weight: .semibold))
                        
                        // Calculator Input Stack
                        VStack(spacing: 12.5) {
                            HStack {
                                
                                // Deposit Input
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Initial Deposit")
                                        .modifier(InputLabel())
                                    TextField("$0.00", text: $deposit)
                                        .modifier(InputTextField())
                                }
                                
                                // Interest Rate Input
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Interest Rate")
                                        .modifier(InputLabel())
                                    TextField("0%", text: $interest)
                                        .modifier(InputTextField())
                                }
                            }
                            HStack {
                                
                                // Monthly Additions Input
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Monthly Addition")
                                        .modifier(InputLabel())
                                    TextField("$0.00", text: $addition)
                                        .modifier(InputTextField())
                                }
                                
                                // Years Input
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Years")
                                        .modifier(InputLabel())
                                    TextField("0", text: $years)
                                        .modifier(InputTextField())
                                }
                            }
                            // Calculate Button
                            Button(
                                action: {
                                    // Check that inputs are valid, if not display alert
                                    if (deposit == "0" || deposit == "") || (years == "0" || years == "") || (interest == "0" || interest == "") {
                                        alert = true
                                    }
                                    else {
                                        // Run calculate function and update output textfields
                                        let result = Calculate(deposit: deposit, interest: interest, addition: addition, years: years)
                                        self.futureValue = result.futureValue
                                        self.futureInterest = result.futureInterest
                                        self.futureDeposits = result.futureDeposits
                                        self.chartWidth = result.chartValue
                                        
                                        // Build the interest-deposit graph
                                        data.removeAll()
                                        data2.removeAll()
                                        buildGraph = true
                                        let plots = CreateGraph(deposit: deposit, intRate: interest, monthAdd: addition, year: years)
                                        self.data = plots.data
                                        self.data2 = plots.data2
                                        self.endEditing(true)
                                        withAnimation {
                                            scrollView.scrollTo("FutureValue", anchor: .center)
                                        }
                                        
                                    }
                                },
                                label: {Text("Calculate").modifier(CalculateButton())})
                        }
                        .frame(maxWidth: .infinity, maxHeight: 210, alignment: .center)
                        .modifier(Containers())
                        
                        // Missing/Incorrect Inputs Alert
                        .alert(isPresented: $alert) {
                            Alert(title: Text("Incorrect Values"), message: Text("Please make sure all values have been entered correctly."), dismissButton: .default(Text("Got it!")))
                        }
                        
                        // Results Container
                        VStack(alignment: .center, spacing: 5) {
                            
                            // Future Value Output
                            Text("Future Value")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color.gray)
                                .offset(y: -5)
                            
                            TextField("$0.00", text: $futureValue)
                                .font(.system(size: 27, weight: .semibold))
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                                .offset(y: -10)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            
                            // Render Estimated Deposit/Interest Ratio Bar
                            HStack(alignment: .center) {
                                BarView(value: CGFloat(chartWidth))
                            }
                            
                            // Estimated Interest Earned Stack
                            HStack {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .background(Circle().foregroundColor(Color("Interest")))
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Text("Interest Earned")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("InputLabel"))
                                    .padding(.leading, 5)
                                
                                Spacer()
                                
                                TextField("$0.00", text: $futureInterest)
                                    .modifier(OutputTextField())
                            }
                            
                            // Estimated Total Deposits Stack
                            HStack {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .background(Circle().foregroundColor(Color.blue))
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Text("Total Deposits")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color("InputLabel"))
                                    .padding(.leading, 5)
                                
                                Spacer()
                                
                                TextField("$0.00", text: $futureDeposits)
                                    .modifier(OutputTextField())
                            }
                            .id("FutureValue")
                            
                            // Graph Container
                            VStack(alignment: .center){
                                        
                                // Render the Chart View using the data plots
                                if buildGraph {
                                    ChartView(data: data2, data2: data, years: years, total: futureValue)
                                        .modifier(GraphStack())
                                        .padding(.top, 20)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .animation(.easeInOut(duration: 1))
                        .modifier(Containers())
                        Spacer()
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            
        }
        //.background(Color("Background").edgesIgnoringSafeArea(.top))
        .onTapGesture {self.endEditing(true)}
    }
    
}

// CreateGraph Function - calculates all the data plots for the deposit-interest graph
func CreateGraph(deposit: String, intRate: String, monthAdd: String, year: String) -> (data: [Point], data2: [Point]) {
        
    var data: [Point] = []
    var data2: [Point] = []
    
        let P = Double(deposit) ?? 0.0
        let r = ((Double(intRate) ?? 0.0)/100)/12
        let t = (Double(year) ?? 0.0)*12
        let M = Double(monthAdd) ?? 0.0
        let f = Int(t/12)
        
        for val in 1...f {
            
            let val2 = val*12
            let endSum = (M * ((pow(r + 1, Double(val2)) - 1) / r))
            let endSum2 = endSum + (P * (pow((1 + r), Double(val2))))
            let endDeposits = P + (M * Double(val2))
            
            let yearF = CGFloat(val)
            let sumF = CGFloat(endSum2)
            let depoF = CGFloat(endDeposits)
            
            data2.append(Point(x: yearF, y: sumF))
            data.append(Point(x: yearF, y: depoF))
        }
    
        return(data, data2)
}


// Calculate Function - formula to calculate the future value of investment
func Calculate(deposit: String, interest: String, addition: String, years: String) -> (futureValue: String, futureInterest: String, futureDeposits: String, chartValue: Double) {
    
    let P = Double(deposit) ?? 0.0
    let r = ((Double(interest) ?? 0.0)/100)/12
    let t = (Double(years) ?? 0.0)*12
    let M = Double(addition) ?? 0.0
        
    let endSum = (M * ((pow(r + 1, t) - 1) / r)) + (P * (pow((1 + r), t)))
    let endDeposits = P + (M * t)
    let endInterest = endSum - endDeposits
        
    let futureValue = NumberFormatter.localizedString(from: NSNumber(value: (round(endSum*100))/100.0), number: .currency)
    let futureInterest = NumberFormatter.localizedString(from: NSNumber(value: (round(endInterest*100))/100.0), number: .currency)
    let futureDeposits = NumberFormatter.localizedString(from: NSNumber(value: (round(endDeposits*100))/100.0), number: .currency)
    let chartValue = endInterest / endSum
    
    return (futureValue, futureInterest, futureDeposits, chartValue)
    
}


// Graph Data Point Declaration
struct Point {
    let x: CGFloat
    let y: CGFloat
}

// ChartView for the Interest-Deposit Graph
struct ChartView: View {
    
    @State private var isPresented: Bool = false
    
    let data: [Point]
    let data2: [Point]
    let years: String
    let total: String
    
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
            GraphTemplate
        }
    }
    
    // Draw and Render the Interest earned
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
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color("Interest"),
                style: StrokeStyle(lineWidth: 5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.7))
        }
        .onAppear {
            self.isPresented = true
        }
    }
    
    // Draw and Render the Deposits made
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
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color.blue,
                style: StrokeStyle(lineWidth: 5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.5))
        }
        .onAppear {
            self.isPresented = true
        }
    }
    
    // Draw and Render the Graph Template
    private var GraphTemplate: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: -3))
                path.addLine(to: .init(x: 0, y: geometry.size.height))
                
                path.move(to: .init(x: 0, y: geometry.size.height ))
                path.addLine(to: .init(x: geometry.size.width, y: geometry.size.height))
            }
            .offset(y: 2)
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color.black,
                style: StrokeStyle(lineWidth: 2.5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.2))
  
            Text("0")
                .offset(x: -10, y: 187.5)
                .modifier(OutputTextField())
            
            Text(years)
                .offset(x: (geometry.size.width)-10, y: 187.5)
                .modifier(OutputTextField())
            
            Path { path in
                path.move(to: .init(x: 0, y: 0 ))
                path.addLine(to: .init(x: geometry.size.width, y: 0))
            }
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color("Interest"),
                style: StrokeStyle(lineWidth: 2.5, dash: [5])
            )
            .animation(Animation.easeInOut(duration: 1).delay(1))
            
            Text(total)
                .modifier(OutputTextField())
                .padding(.trailing,5)
                .background(Color.white)
                .offset(x: 1, y: -10)
        }
        .onAppear {
            self.isPresented = true
        }
    }
}


// Input Label View Modifier
struct InputLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color("InputLabel"))
    }
}

// Input Text Field View Modifier
struct InputTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 45)
            .padding(.leading)
            .font(.system(size: 18, weight: .bold))
            .keyboardType(.decimalPad)
            .background(
                RoundedRectangle(cornerRadius: 7.5)
                    .fill(Color("TextFieldBackground"))
            )
    }
}

struct OutputTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color.black)
            .padding(.leading, 5)
            .multilineTextAlignment(.trailing)
            .disabled(true)
    }
}

// Calculate Button View Modifier
struct CalculateButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 23, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 58, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .shadow(color: Color("ContainerShadow"), radius: 5, x: 1, y: 1)
            )
    }
}

// Default Stack Container View Modifier
struct Containers: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color("ContainerShadow"), radius: 5, x: 1, y: 1))
    }
}

struct GraphStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 180)
            .padding()
            .padding(.bottom,30)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
            )
    }
}

// Estimated Deposit/Interest Ratio Bar View
struct BarView: View{
    var value: CGFloat
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .frame(width: geometry.size.width / 1, height: 20)

                RoundedRectangle(cornerRadius: 15)
                    .frame(width: geometry.size.width / (1/(value)), height: 20)
                    .foregroundColor(Color("Interest"))
                    .animation(.easeInOut(duration: 1))
            }
        }.frame(height: 30)
    }
}

// Dismiss Keyboard Function
extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .previewDevice("iPhone 8 Plus")
    }
}

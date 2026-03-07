//
//  MomentView.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/20/25.
//
import SwiftUI
import Charts

struct PersonalPage: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let editedModel: Person
    
    @State var themeColor: Color = Color.red
    @State var name: String = ""
    @State var birthDate: Date = Date.now
    @State var isChineseCalendar: Bool = false
    
    @State var showDeletionAlert: Bool = false
    @State var showEditSheet: Bool = false
    
//    func formBirthdayModel() -> BirthdayModel {
//        let demo = BirthdayModel(name: name, nickname: name, gender: .undefined, birthDate: birthDate, isChineseCalendar: isChineseCalendar, themeColor: ColorComponents.fromColor(themeColor))
//        return demo
//    }
    
    var body: some View {
        VStack(spacing: 15) {
            Image("avatar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
            
            BaseInfoView(editedModel: editedModel)
                .personalCardStyle()
            
            BirthdayCountView(editedModel: editedModel)
                .personalCardStyle()
            
            GiftSentView(editedModel: editedModel)
                .personalCardStyle()
            
            WishListView(model: editedModel)
                .personalCardStyle()
            
            BirthdayMomentView(model: editedModel)
                .personalCardStyle()
            
            Button(action: {
                showEditSheet = true
            }, label: {
                Label("编辑", systemImage: "pencil")
            })
            .foregroundStyle(Color(uiColor: .label))
            .buttonStyle(.personalButton)
            .padding(.top)
            
            Button(action: {
                showDeletionAlert = true
            }, label: {
                Label("删除", systemImage: "trash")
            })
            .foregroundStyle(.red)
            .buttonStyle(.personalButton)
            .padding(.bottom)
            
            Spacer()
        }
        .alert("Do you want to delete this person ?", isPresented: $showDeletionAlert) {
            Button("Confirm", role: .destructive) {
                dismiss()
                context.delete(editedModel)
                try! context.save()
                showDeletionAlert = false
            }
            Button("Cancel", role: .cancel) {
                showDeletionAlert = false
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditPersonalView(editedModel: editedModel)
        }
        
    }
}

struct PersonalView: View {
    let editedModel: Person
    
    @State var safeAreaInsets: EdgeInsets = .init()
    @State var scrollOffset: CGFloat = 0

    init(editedModel: Person? = nil) {
        if let editedModel = editedModel {
            self.editedModel = editedModel
        } else {
            self.editedModel = Person(name: "未命名", nickname: "无", gender: .male, birthDate: .now, birthdayCalendar: .undefined, themeColor: ColorComponents.fromColor(Color.getRandomColor()))
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                PersonalPage(editedModel: editedModel)
            }
            .background(LinearGradient(
                gradient: Gradient(colors: [editedModel.themeColor.color.opacity(0.6), Color.white.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { oldValue, newValue in
                scrollOffset = newValue
            }
            .overlay {
                VStack {
                    self.navigation(safeAreaTop: proxy.safeAreaInsets.top, scrollOffset: scrollOffset, name: editedModel.name, color: editedModel.themeColor.color)
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    func navigation(safeAreaTop: CGFloat, scrollOffset: CGFloat, name: String, color: Color) -> some View {
        let height = safeAreaTop + 44
        let progress: CGFloat
        
        progress = min(1, max(0, (scrollOffset - height - 20) / 44))
        
        return CustomNavBar(progress: Double(progress), name: name, bgColor: color)
            .frame(height: height)
    }
    
    struct CustomNavBar: View {
        let progress: Double
        let name: String
        let bgColor: Color
        
        var body: some View {
            ZStack(alignment: .bottom) {
                
                Color(uiColor: colorScheme == .light ? .white : .black)
                    .opacity(progress)
                    .contentShape(Rectangle())
                    
                
                bgColor
                    .opacity(progress / 3)
                    .contentShape(Rectangle())
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                    .padding()
                    
                    Spacer()
                    
                }
                .accentColor(Color(white: colorScheme == .light ? 1 - progress : 1))
                .frame(height: 44)
                
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .opacity(progress)
                    .frame(height: 44, alignment: .center)
            }
            .frame(maxWidth: .infinity)
        }
        
        @Environment(\.colorScheme) var colorScheme
        @Environment(\.presentationMode) var presentationMode
    }
}

/// For swipe left to right go back last page, when navigation bar is hidden
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct PersonalCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .shadow(color: Color(uiColor: .label).opacity(0.1), radius: 5, x: 0, y: 10)
    }
}

struct PersonalButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: UIColor.systemBackground))
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal)
    }
}

struct PersonalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color(uiColor: .label).opacity(0.3) : .clear)
            .background(Color(uiColor: UIColor.systemBackground))
            .clipShape(.rect(cornerRadius: 10))
            .compositingGroup()
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
            .shadow(color: Color(uiColor: .label).opacity(0.1), radius: 5, x: 0, y: 10)
    }
}

extension ButtonStyle where Self == PersonalButtonStyle {
    static var personalButton:PersonalButtonStyle {
        PersonalButtonStyle()
    }
}

extension View {
    func personalCardStyle() -> some View {
        self.modifier(PersonalCardModifier())
    }
}


struct BaseInfoView: View {
    let editedModel: Person
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("基础信息")
                    .bold()
                Spacer()
            }
            Divider()
            
            HStack {
                Text(editedModel.name)
                    .font(.largeTitle)
                Spacer()
                Text("\(editedModel.age)")
                    .font(.largeTitle)
            }
            
            HStack {
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50)
                    .clipShape(.circle)
                
                Spacer()
                VStack(alignment: .trailing) {
                    Text(editedModel.birthdayCalendar == .nongli ? "农历 " + editedModel.birthDateInChineseCalendar.monthDayDescription() : "公历 " + editedModel.birthDate.monthdayCHString)
                    Text("出生于\(editedModel.birthDate.dateToString(stringFormat: "yyyy年MM月dd日"))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct BirthdayCountView: View {
    let editedModel: Person
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("生日倒计时")
                    .bold()
                Spacer()
            }
            Divider()
            
            HStack {
                Spacer()
                Text("距\(editedModel.nextBirthday.dateToString(stringFormat: "yyyy年MM月dd日"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
            }
            
            
            HStack {
                if editedModel.isBirthdayToday {
                    Text("Happy birthday !")
                        .font(.title)
                    Spacer()
                    Image(systemName: "gift")
                        .font(.title)
                } else {
                    let daycnt = editedModel.daysToNextBirthday
                    let progresscnt = Int(Double(366 - daycnt) / Double(366) * 100)
                    AnimatedRingView(ring: Ring(progress: CGFloat(progresscnt), value: "Steps", keyIcon: "figure.walk", keyColor: editedModel.themeColor.color))
                        .frame(width: 100)
                    Spacer()
                    HStack {
                        Text("\(daycnt)")
                            .font(.title)
                        Text("days")
                    }
                }
            }
            .padding()
            .cornerRadius(10)
        }
    }
}

struct PostCount {
  var category: String
  var count: Int
}

struct GiftSentView: View {
    let editedModel: Person
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("送礼历史")
                    .bold()
                Spacer()
            }
            Divider()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(editedModel.sentGifts, id: \.self) { gift in
                        SingleGiftCard(gift: gift)
                    }
                }
            }
            .scrollIndicators(.hidden)
            
            
            
            GiftPieChartView(data: [
                .init(category: "Xcode", count: 79),
                .init(category: "Swift", count: 73),
                .init(category: "SwiftUI", count: 58),
                .init(category: "WWDC", count: 15),
                .init(category: "SwiftData", count: 9)
              ])
            
            
        }
    }
}

struct WishListView: View {
    let model: Person?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("愿望清单")
                    .bold()
                Spacer()
            }
            Divider()
        }
    }
}

struct BirthdayMomentView: View {
    let model: Person?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("生日瞬间")
                    .bold()
                Spacer()
            }
            Divider()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<5) { idx in
                        ZStack {
                            Image("birthday_demo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 300)
                                .clipShape(.rect(cornerRadius: 10))
                            
                            VStack {
                                Text("\(2025 - idx)年10月18日")
                                    .padding(.horizontal)
                                    .background(.ultraThinMaterial)
                                    .clipShape(.rect(cornerRadius: 5))
                                Spacer()
                                
                                NavigationLink(destination: {
                                    Text("123")
                                }, label: {
                                    Text("进入回忆")
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .clipShape(.capsule)
                                })

                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct GiftPieChartView: View {
    let data: [PostCount]
    
    @State private var selectedAngle: Double?
    
    private let categoryRanges: [(category: String, range: Range<Double>)]
    private let totalPosts: Int
    
    //@State private var selectedItem: PostCount? = nil

    init(data: [PostCount]) {
      self.data = data
      var total = 0
      categoryRanges = data.map {
        let newTotal = total + $0.count
        let result = (category: $0.category,
                      range: Double(total) ..< Double(newTotal))
        total = newTotal
        return result
      }
      self.totalPosts = total
    }
    
//    func updateSelectedItem() {
//        guard let selectedAngle else { return }
//        if let selected = categoryRanges.firstIndex(where: {
//          $0.range.contains(selectedAngle)
//        }) {
//            selectedItem = data[selected]
//        }
//        return
//    }
    
    var selectedItem: PostCount? {
        guard let selectedAngle else { return nil}
        if let selected = categoryRanges.firstIndex(where: {
            $0.range.contains(selectedAngle)
        }) {
            return data[selected]
        }
        return nil
    }
    
    var titleView: some View {
      VStack {
        Text(selectedItem?.category ?? "Categories")
          .font(.title)
        Text((selectedItem?.count.formatted() ?? totalPosts.formatted()) + " posts")
          .font(.callout)
      }
    }
    
    var body: some View {
        Chart(data, id: \.category) { item in
          SectorMark(
            angle: .value("Count", item.count),
            innerRadius: .ratio(0.6),
            angularInset: 2
          )
          .cornerRadius(5)
          .foregroundStyle(by: .value("Category", item.category))
          .opacity(item.category == selectedItem?.category ? 1 : 0.5)
        }
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 16)
        .chartAngleSelection(value: $selectedAngle)
        //.onChange(of: selectedAngle, updateSelectedItem)
        .chartBackground { chartProxy in
          GeometryReader { geometry in
            if let anchor = chartProxy.plotFrame {
               let frame = geometry[anchor]
              titleView
                .position(x: frame.midX, y: frame.midY)
            }
          }
        }
//        .chartGesture { chart in
//            SpatialTapGesture().onEnded { event in
//                let angle = chart.angle(at: event.location)
//                chart.selectAngleValue(at: angle)
//            }
//        }
        .padding()
    }
}

struct SingleGiftCard: View {
    let gift: GiftModel
    
    var body: some View {
        HStack(spacing: 5) {
            VStack {
                Image(systemName: "gift")
                Text(gift.giftType.rawValue)
            }
            .foregroundStyle(.white)
            .padding(.all, 10)
            .background(.blue)
            
            VStack(alignment: .leading) {
                Text(gift.giftDesc)
                
                Spacer()
                   
                    
                Text(gift.sentDate.dateToString(stringFormat: "yyyy-MM-dd")).font(.caption)
                    .foregroundStyle(.secondary)
                
            }
            .frame(width: 100, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke()
                .fill(Color(uiColor: .label))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        )
    }
}

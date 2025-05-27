import SwiftUI

struct FamilyMember: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var iconName: String // アイコン名
    var color: ColorData
    var level: Int = 1
    var experience: Int = 0
    var routines: [Routine] = [
        Routine(name: "あさ", tasks: Task.defaultMorningTasks),
        Routine(name: "よる", tasks: Task.defaultNightTasks)
    ]
}

struct Routine: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var tasks: [Task]
}

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var iconName: String
    var color: ColorData
    var isCompleted: Bool = false

    static let defaultMorningTasks: [Task] = [
        Task(name: "おきた", iconName: "sun.max.fill", color: ColorData(.blue)),
        Task(name: "うがいをする", iconName: "drop.fill", color: ColorData(.teal)),
        Task(name: "かおをあらう", iconName: "face.smiling", color: ColorData(.cyan)),
        Task(name: "おきがえをする", iconName: "tshirt.fill", color: ColorData(.orange)),
        Task(name: "あさごはんをたべる", iconName: "fork.knife", color: ColorData(.yellow)),
        Task(name: "みだしなみをととのえる", iconName: "scissors", color: ColorData(.mint)),
        Task(name: "でるじゅんびをする", iconName: "bag.fill", color: ColorData(.purple)),
        Task(name: "でるじかんまであそぶ", iconName: "gamecontroller.fill", color: ColorData(.pink)),
        Task(name: "いえをでる", iconName: "house.fill", color: ColorData(.indigo))
    ]
    static let defaultNightTasks: [Task] = [
        Task(name: "ただいま", iconName: "house.fill", color: ColorData(.indigo)),
        Task(name: "てあらい", iconName: "hands.sparkles.fill", color: ColorData(.teal)),
        Task(name: "うがい", iconName: "drop.fill", color: ColorData(.cyan)),
        Task(name: "あらいものをだす", iconName: "fork.knife", color: ColorData(.yellow)),
        Task(name: "しゅくだい", iconName: "book.fill", color: ColorData(.orange)),
        Task(name: "あしたのじゅんび", iconName: "bag.fill", color: ColorData(.purple)),
        Task(name: "あそぶ", iconName: "gamecontroller.fill", color: ColorData(.pink)),
        Task(name: "おへやのおかたづけ", iconName: "cube.box.fill", color: ColorData(.mint)),
        Task(name: "よるごはん", iconName: "fork.knife", color: ColorData(.yellow)),
        Task(name: "はみがき", iconName: "mouth.fill", color: ColorData(.blue)),
        Task(name: "トイレ", iconName: "toilet.fill", color: ColorData(.gray)),
        Task(name: "パジャマをきる", iconName: "tshirt.fill", color: ColorData(.orange)),
        Task(name: "おやすみ", iconName: "moon.fill", color: ColorData(.indigo)),
        Task(name: "ならいごとのしゅくだい", iconName: "book.fill", color: ColorData(.orange))
    ]
}

struct ColorData: Codable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(_ color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        red = Double(r)
        green = Double(g)
        blue = Double(b)
        opacity = Double(a)
    }
    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
} 
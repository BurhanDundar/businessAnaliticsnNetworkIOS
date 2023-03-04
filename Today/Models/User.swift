/*
 See LICENSE folder for this sample’s licensing information.
 */

import Foundation

struct User: Identifiable{
    var id: String = UUID().uuidString
    var full_name: String
    var title: String
    var image: String
    var about: String
    var connection_count: String
    var location: String
    var isBookmarked: Bool = false
    var skills: [Skill] = []
}

extension [User] {
    func indexOfUser(withId id: User.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}

#if DEBUG
extension User{
    static var sampleData = [
        User(full_name: "Murat Osman Ünalır",
            title: "Prof.Dr. at Department of Computer Engineering, Ege University",
            image: "https://media.licdn.com/dms/image/C4D03AQFBJms9OsMrCg/profile-displayphoto-shrink_400_400/0/1636138737205?e=1681344000&v=beta&t=o8IBOg-QnfGZmv50p5pK0FIo86yOeMr-if4I_BqbTB0",
            about: "25 years of experience in teaching data management.https://avesis.ege.edu.tr/murat.osman.unalir/",
            connection_count: "500+",
            location: "İzmir, Türkiye",
             skills: [
                 Skill(title: "Yüzmek"),
                 Skill(title: "Koşmak"),
                 Skill(title: "Database Design")
                 ]
            ),
        User(
            full_name: "Emine Sezer",
            title: "Yrd. Doç. Dr., Ege Üniversitesi",
            image: "https://media.licdn.com/dms/image/C4E03AQHgThhmcBQdRg/profile-displayphoto-shrink_400_400/0/1517045656274?e=1681344000&v=beta&t=5LYcpnI8x0xYsg-YMOu-dhK9VxB6CT0IEr59ZBps1o0",
            about: "",
            connection_count: "500+",
            location: "İzmir, Türkiye")
    ]
}
#endif

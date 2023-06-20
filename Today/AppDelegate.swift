/*
 See LICENSE folder for this sample’s licensing information.
 */

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let APIURL: String = "http://192.168.1.101:3001"
    var userSkills = [Skill]()
    var userExperiences = [Experience]()
    var userEducations = [Education]()
    var userCourses = [Course]()
    var userLanguages = [Language]()
    
    var UserSpecialFilterUsers = [User]()
    
    var memberUserFavs = [String]()
    var memberCompanyFavs = [String]()
    var memberMemberFavs = [String]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

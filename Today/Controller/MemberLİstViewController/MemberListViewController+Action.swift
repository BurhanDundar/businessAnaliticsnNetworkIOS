//
//  MemberListViewController+Action.swift
//  Today
//
//  Created by Şerife Türksever on 7.06.2023.
//

import UIKit

extension MemberListViewController {
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        self.showSpinner()
        self.listStyleSegmentedControl.isEnabled = false
            // index -> 0: all, 1: bookmarked
        var res = [Member]()
        var members = [Member]()
            if(sender.selectedSegmentIndex == 0){
                Task{
                        do {
                            members = try await getAllMembers()
                            } catch {
                                print("Oops!")
                            }
                }
                self.listStyleSelectedIndex = 0
                self.members = members
                updateSnapshot(for: self.members)
                    
            } else if(sender.selectedSegmentIndex == 1){
                Task{
                        do {
                            res = try await getBookmarkedMembers()
                            } catch {
                                print("Oops!")
                            }
                }
                self.listStyleSelectedIndex = 1
                self.filteredMembers = res
                updateSnapshot(for: self.filteredMembers)
            }
            
            }
}

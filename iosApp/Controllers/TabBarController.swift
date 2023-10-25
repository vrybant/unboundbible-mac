//
//  TabBarController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 25.10.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.items?[0].title = "Библия"
        selectedIndex = UserDefaults.standard.integer(forKey: "TabBarIndex")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.title!)
        print(selectedIndex)
        if let index = tabBar.items?.firstIndex(where: {$0 == item}) {
            print(index)
            UserDefaults.standard.set(index, forKey: "TabBarIndex")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

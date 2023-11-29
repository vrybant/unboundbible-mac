//
//  TabBarController.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 25.10.2023.
//  Copyright © 2023 Vladimir Rybant. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.items?[0].title = "Библия"
        selectedIndex = UserDefaults.standard.integer(forKey: "TabBarIndex")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(where: {$0 == item}) {
            UserDefaults.standard.set(index, forKey: "TabBarIndex")
        }
        
    }

    // https://www.youtube.com/watch?v=-XJqk_MEB6I
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

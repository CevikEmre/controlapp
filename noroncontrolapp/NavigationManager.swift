import Foundation

class NavigationManager: ObservableObject {
   @Published var navigationStack: [MainView.MenuItem] = [.home]

   func push(_ view: MainView.MenuItem) {
       navigationStack.append(view)
   }

   func pop() {
       if navigationStack.count > 1 {
           navigationStack.removeLast()
       }
   }

   var currentView: MainView.MenuItem {
       navigationStack.last ?? .home
   }
}

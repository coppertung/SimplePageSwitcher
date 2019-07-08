import Foundation

protocol PageSwitcherDataSource {
    
    /**
     *
     * Get the view controller using storyboard and storyboard ID.
     *
     * - Parameter view: The container of the page switcher.
     * - Parameter storyboard: The storyboard contains the target view controller.
     * - Parameter viewControllerID: The storyboard ID contains the target view controller.
     *
    */
    func registerPage(_ view: UIView, storyboard: UIStoryboard, viewControllerID: String) -> UIViewController
    /**
     *
     * Get the view controller using storyboard name and storyboard ID.
     *
     * - Parameter view: The container of the page switcher.
     * - Parameter storyboardName: The name of storyboard contains the target view controller.
     * - Parameter viewControllerID: The storyboard ID contains the target view controller.
     *
     */
    func registerPage(_ view: UIView, storyboardName: String, viewControllerID: String) -> UIViewController
    
}

extension PageSwitcherDataSource {
    
    func registerPage(_ view: UIView, storyboard: UIStoryboard, viewControllerID: String) -> UIViewController {
        
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        return vc
        
    }
    
    func registerPage(_ view: UIView, storyboardName: String, viewControllerID: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        return vc
        
    }
    
}

import Foundation

protocol PageSwitcherDelegate {
    
    /**
     *
     * Return the view controller which contains the page switcher.
     *
    */
    func getParentViewController() -> UIViewController
    /**
     *
     * Being called as ViewWillAppear function of the view controller attached in the appearing page.
     * Appearing page's ViewWillAppear function will be involved by default.
     *
     * - Parameter vc: Appearing page's view controller.
     *
     */
    func onViewWillAppear(_ vc: UIViewController)
    /**
     *
     * Being called as ViewDidAppear function of the view controller attached in the appearing page.
     * Appearing page's ViewDidAppear function will be involved by default.
     *
     * - Parameter vc: Appearing page's view controller.
     *
     */
    func onViewDidAppear(_ vc: UIViewController)
    /**
     *
     * Being called as ViewWillDisappear function of the view controller attached in the disappearing page.
     * Disappearing page's ViewWillDisappear function will be involved by default.
     *
     * - Parameter vc: Disappearing page's view controller.
     *
     */
    func onViewWillDisappear(_ vc: UIViewController)
    /**
     *
     * Being called as ViewDidDisappear function of the view controller attached in the disappearing page.
     * Disappearing page's ViewDidDisappear function will be involved by default.
     *
     * - Parameter vc: Disappearing page's view controller.
     *
     */
    func onViewDidDisappear(_ vc: UIViewController)
    
}

extension PageSwitcherDelegate {
    
    func onViewWillAppear(_ vc: UIViewController) {
        
        vc.viewWillAppear(false)
        
    }
    
    func onViewDidAppear(_ vc: UIViewController) {
        
        vc.viewDidAppear(false)
        
    }
    
    func onViewWillDisappear(_ vc: UIViewController) {
        
        vc.viewWillDisappear(false)
        
    }
    
    func onViewDidDisappear(_ vc: UIViewController) {
        
        vc.viewDidDisappear(false)
        
    }
    
}

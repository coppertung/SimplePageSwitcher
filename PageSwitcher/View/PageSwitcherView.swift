import UIKit

class PageSwitcherView: UIView {

    // MARK: Enumerations
    
    /**
     *
     * Enumeration for Page Switcher direction. There will be only horizontal and vertical.
     *
 `  */
    enum SwitchDirection: String {
        case Horizontal
        case Vertical
    }
    
    // MARK: Constants
    
    /**
     *
     * The origin of self frame.
     *
    */
    var refPoint: CGPoint {
        get {
            return self.frame.origin
        }
    }
    
    // MARK: Properties
    
    // Animation part
    @IBInspectable var isAnimated: Bool = false
    @IBInspectable var animationDuration: Double = 0.2
    
    var delegate: PageSwitcherDelegate?
    private var _dataSource: PageSwitcherDataSource?
    var dataSource: PageSwitcherDataSource {
        set {
            _dataSource = newValue
        }
        get {
            return _dataSource ?? self
        }
    }
    
    var pages = [UIView]()
    var pageVCs = [UIViewController]()
    
    var numberOfPages: Int {
        get {
            return pageVCs.count
        }
    }
    var switchDirection: SwitchDirection = .Horizontal
    var currentPage: Int = 0
    
    // MARK: Initializations
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        if !self.clipsToBounds {
            self.clipsToBounds = true
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        if !self.clipsToBounds {
            self.clipsToBounds = true
        }
        
    }
    
    // MARK: Functions
    
    /**
     *
     * Reload all pages to page switcher.
     *
    */
    func reloadPages() {
        
        self.pages.removeAll()
        for pageVC in pageVCs {
            self.addPageByVC(vc: pageVC)
        }
        initialPage()
        
    }
    
    /**
     *
     * Switch to specific pages.
     *
     * - Parameter pageNum: The page number of target page.
     *
     */
    func switchPage(to pageNum: Int) {
        
        if self.pages.count > 0 && pageNum < self.pageVCs.count && self.currentPage != pageNum {
            if self.isAnimated {
                // previous page get out
                self.delegate?.onViewWillDisappear(self.pageVCs[self.currentPage])
                UIView.animate(withDuration: self.animationDuration, animations: {
                    () -> Void in
                    let targetX = (self.switchDirection == .Horizontal ? (pageNum > self.currentPage ? -self.frame.width : self.frame.width) : 0)
                    let targetY = (self.switchDirection == .Vertical ? (pageNum > self.currentPage ? -self.frame.height : self.frame.height) : 0)
                    self.pages[self.currentPage].frame = CGRect(x: targetX, y: targetY, width: self.frame.width, height: self.frame.height)
                }, completion: {
                    (finished) -> Void in
                    self.pages[self.currentPage].isHidden = true
                    self.delegate?.onViewDidDisappear(self.pageVCs[self.currentPage])
                    self.currentPage = pageNum
                })
                // current page get in
                self.delegate?.onViewWillAppear(self.pageVCs[pageNum])
                self.pages[pageNum].isHidden = false
                UIView.animate(withDuration: self.animationDuration, animations: {
                    () -> Void in
                    self.pages[pageNum].frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                }, completion: {
                    (finished) -> Void in
                    self.delegate?.onViewDidAppear(self.pageVCs[pageNum])
                })
            }
            else {
                self.delegate?.onViewWillDisappear(self.pageVCs[self.currentPage])
                self.pages[self.currentPage].isHidden = true
                self.delegate?.onViewDidDisappear(self.pageVCs[self.currentPage])
                self.delegate?.onViewWillAppear(self.pageVCs[pageNum])
                self.pages[pageNum].isHidden = false
                self.delegate?.onViewDidAppear(self.pageVCs[pageNum])
                self.currentPage = pageNum
            }
            setFrontSubview(subview: self.pages[pageNum])
        }
        
    }
    
    /**
     *
     * Add page which is in the same storyboard to page switcher.
     *
     * - Parameter identifier: The storyboard ID of the page.
     *
     */
    func addPage(with identifier: String) -> UIViewController {
        
        let parent = self.delegate?.getParentViewController() ?? self.viewContainingController
        let vc = self.dataSource.registerPage(self, storyboard: parent!.storyboard!, viewControllerID: identifier)
        self.pageVCs.append(vc)
        reloadPages()
        return vc
        
    }
    
    /**
     *
     * Add page which is in different storyboard to page switcher.
     *
     * - Parameter storyboard: The storyboard name of the page.
     * - Parameter identifier: The storyboard ID of the page.
     *
     */
    func addPage(from storyboard: String, with identifier: String) -> UIViewController {
        
        let vc = self.dataSource.registerPage(self, storyboardName: storyboard, viewControllerID: identifier)
        self.pageVCs.append(vc)
        reloadPages()
        return vc
        
    }
    
    /**
     *
     * Remove specific page from page switcher.
     *
     * - Parameter vc: The view controller of the target page.
     *
     */
    func removePage(vc: UIViewController) {
        
        if let item = self.pageVCs.first(where: { $0 == vc }) {
            let index = self.pageVCs.indexOfObject(item)
            removePage(at: index)
        }
        
    }
    
    /**
     *
     * Remove specific page from page switcher.
     *
     * - Parameter index: The index of the target page.
     *
     */
    func removePage(at index: Int) {
        
        if index < self.pageVCs.count {
            self.pageVCs.remove(at: index)
            reloadPages()
        }
        
    }
    
    /**
     *
     * Remove all pages from page switcher.
     *
     */
    func removeAll() {
        
        self.pageVCs.removeAll()
        reloadPages()
        
    }
    
    // MARK: Private Functions
    
    private func initialPage() {
        
        self.pages[0].isHidden = false
        self.pageVCs[0].viewDidAppear(false)
        let targetX = (self.switchDirection == .Horizontal ? self.frame.width : 0)
        let targetY = (self.switchDirection == .Vertical ? self.frame.height : 0)
        for i in 1..<self.pages.count {
            self.pages[i].isHidden = true
            if self.isAnimated {
                self.pages[i].frame = CGRect(x: targetX, y: targetY, width: self.frame.width, height: self.frame.height)
            }
        }
        
    }
    
    private func addPageByVC(vc: UIViewController) {
        
        let parent = self.delegate?.getParentViewController() ?? self.viewContainingController
        
        vc.view.frame = self.bounds
        parent!.addChildViewController(vc)
        self.addSubview(vc.view)
        vc.didMove(toParentViewController: parent)
        
        self.pages.append(vc.view)
        
    }
    
    private func setFrontSubview(subview: UIView) {
        
        self.bringSubview(toFront: subview)
        
    }
    
}

extension PageSwitcherView: PageSwitcherDataSource { }

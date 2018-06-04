//
//  UIKit.swift
//  Tempus
//
//  Created by Giancarlo on 23.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

// MARK: - UIView Extensions

public extension UIView {
    
    /// Adds the selected view to the superview and create constraints through the closure block
    public func add(subview: UIView, createConstraints: (_ view: UIView, _ parent: UIView) -> ([NSLayoutConstraint])) {
        addSubview(subview)

        subview.activate(constraints: createConstraints(subview, self))
    }
    
    // Pins the given constraints to the view (Not yet used)
    public func createConstraints(for subview: UIView, topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, leadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, trailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        self.add(subview: subview) { (v, p) in [
            v.topAnchor.constraint(equalTo: topAnchor),
            v.leadingAnchor.constraint(equalTo: leadingAnchor),
            v.trailingAnchor.constraint(equalTo: trailingAnchor),
            v.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]}
    }
    
    /// Removes specified views in the array
    public func remove(subviews: [UIView]) {
        subviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    /// Activates the given constraints
    public func activate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Deactivates the give constraints
    public func deactivate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.deactivate(constraints)
    }
    
    /// Lays out the view to fill the superview
    public func fillToSuperview(_ subview: UIView) {
        self.add(subview: subview) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    /// Hides view with animation parameter
    public func hide(_ force: Bool, duration: TimeInterval, transition: UIViewAnimationOptions) {
        UIView.transition(with: self, duration: duration, options: transition, animations: {
            self.isHidden = force
        })
    }
    
    public func addSeparatorLine(color: UIColor) {
        let view = UIView()
        view.backgroundColor = color
        add(subview: view) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.5)
            ]}
    }

}


// MARK: - ReusableView Protocol & Configurable

/// Protocol for making dataSourcing a cell easier
public protocol Configurable {
    associatedtype T
    var model: T? { get set }
    func configureWithModel(_: T)
}

/// Protocol for setting the defaultReuseIdentifier
public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    
    /// Grabs the defaultReuseIdentifier through the class name
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}


// MARK: - TableView Generics

extension UITableViewCell: ReusableView { }
extension UITableView {
    
    /// Custom Generic function for registering a TableViewCell
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type.self, forCellReuseIdentifier: type.defaultReuseIdentifier)
    }
    
    /// Custom Generic function for dequeueing a TableViewCell
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(type.defaultReuseIdentifier)")
        }
        return cell
    }
    
    /// Deselects row at given IndexPath
    func deselectRow() {
        guard let indexPath = indexPathForSelectedRow else { return }
        self.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - CollectionView Generics

extension UICollectionViewCell: ReusableView { }
extension UICollectionView {
    
    /// Custom Generic function for registering a CollectionViewCell
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type.self, forCellWithReuseIdentifier: type.defaultReuseIdentifier)
    }
    
    /// Custom Generic function for dequeueing a TableViewCell
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(type.defaultReuseIdentifier)")
        }
        
        return cell
    }
}


// MARK: - UIImageView

public extension UIImageView {
    
    public func setImage(_ image: UIImage, with renderingMode: UIImageRenderingMode, tintColor: UIColor) {
        self.image = image.withRenderingMode(renderingMode)
        self.tintColor = tintColor
    }
}

// MARK: - Alert

public extension UIViewController {
    
    /// Wraps the ViewController in a UINavigationController
    public func wrapped() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    /// Shows an alert message
    public func showAlert(title: String, message: String = "", completion: @escaping (() -> ())) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (_) in
            
            completion()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    public func alert(title: String? = nil, message: String? = nil, cancelable: Bool = false, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.okAction(handler))
        
        if cancelable {
            alertController.addAction(.cancelAction())
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    public func alert(error: Error, cancelable: Bool = false, handler: ((UIAlertAction) -> Void)? = nil) {
        let title = "Error"
        
        #if DEBUG
        let message = (error as NSError).userInfo[NSDebugDescriptionErrorKey] as? String ?? error.localizedDescription
        #else
        let message = error.localizedDescription
        #endif
        
        alert(title: title, message: message, cancelable: cancelable, handler: handler)
    }
    
    public var topViewController: UIViewController {
        if let overVC = presentedViewController, !overVC.isBeingDismissed {
            return overVC.topViewController
        }
        return self
    }
}


// MARK: UIAlertAction

extension UIAlertAction {
    public class func okAction(_ handler: ((_ action: UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: "Ok", style: .default, handler: handler)
    }
    
    public class func cancelAction(_ handler: ((_ action: UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: handler)
    }
}


// MARK: - NSAttributedString

public extension NSAttributedString {
    
    static func String(_ string: String, font: UIFont, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.font : font, NSAttributedStringKey.foregroundColor: color])
    }
}


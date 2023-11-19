// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

// TODO: Process for use in SkipUI

#if !SKIP

import struct CoreGraphics.CGSize

/// An effect that changes the visual appearance of a view, largely without
/// changing its ancestors or descendants.
///
/// The only change the effect makes to the view's ancestors and descendants is
/// to change the coordinate transform to and from them.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol GeometryEffect : Animatable, ViewModifier where Self.Body == Never {

    /// Returns the current value of the effect.
    func effectValue(size: CGSize) -> ProjectionTransform
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension GeometryEffect {

    /// Returns an effect that produces the same geometry transform as this
    /// effect, but only applies the transform while rendering its view.
    ///
    /// Use this method to disable layout changes during transitions. The view
    /// ignores the transform returned by this method while the view is
    /// performing its layout calculations.
//    public func ignoredByLayout() -> _IgnoredByLayoutEffect<Self> { fatalError() }
}


#endif

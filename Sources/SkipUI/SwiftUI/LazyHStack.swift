// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP


/// A view that arranges its children in a line that grows horizontally,
/// creating items only as needed.
///
/// The stack is "lazy," in that the stack view doesn't create items until
/// it needs to render them onscreen.
///
/// In the following example, a ``ScrollView`` contains a `LazyHStack` that
/// consists of a horizontal row of text views. The stack aligns to the top
/// of the scroll view and uses 10-point spacing between each text view.
///
///     ScrollView(.horizontal) {
///         LazyHStack(alignment: .top, spacing: 10) {
///             ForEach(1...100, id: \.self) {
///                 Text("Column \($0)")
///             }
///         }
///     }
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct LazyHStack<Content> : View where Content : View {

    /// Creates a lazy horizontal stack view with the given spacing,
    /// vertical alignment, pinning behavior, and content.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. All
    ///       child views have the same vertical screen coordinate.
    ///     - spacing: The distance between adjacent subviews, or `nil` if you
    ///       want the stack to choose a default distance for each pair of
    ///       subviews.
    ///     - pinnedViews: The kinds of child views that will be pinned.
    ///     - content: A view builder that creates the content of this stack.
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init(), @ViewBuilder content: () -> Content) { fatalError() }

    /// The type of view representing the body of this view.
    ///
    /// When you create a custom view, Swift infers this type from your
    /// implementation of the required ``View/body-swift.property`` property.
    public typealias Body = NeverView
    public var body: Body { fatalError() }
}

#endif

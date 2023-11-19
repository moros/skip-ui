// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
#if SKIP
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import coil.compose.SubcomposeAsyncImage
import coil.request.ImageRequest
import coil.size.Size
#endif

public struct AsyncImage /* <Content> */ : View /* where Content : View */ {
    let url: URL?
    let scale: CGFloat
    let content: (AsyncImagePhase) -> any View

    public init(url: URL?, scale: CGFloat = 1.0) /* where Content == Image */ {
        self.url = url
        self.scale = scale
        self.content = { phase in
            switch phase {
            case .empty:
                return Self.defaultPlaceholder()
            case .failure:
                return Self.defaultPlaceholder()
            case .success(let image):
                return image
            }
        }
    }

    public init(url: URL?, scale: CGFloat = 1.0, @ViewBuilder content: @escaping (Image) -> any View, @ViewBuilder placeholder: @escaping () -> any View) {
        self.url = url
        self.scale = scale
        self.content = { phase in
            switch phase {
            case .empty:
                return placeholder()
            case .failure:
                return placeholder()
            case .success(let image):
                return content(image)
            }
        }
    }

    public init(url: URL?, scale: CGFloat = 1.0, transaction: Any? = nil /* Transaction = Transaction() */, @ViewBuilder content: @escaping (AsyncImagePhase) -> any View) {
        self.url = url
        self.scale = scale
        self.content = content
    }

    #if SKIP
    @Composable public override func ComposeContent(context: ComposeContext) {
        guard let url else {
            let _ = self.content(AsyncImagePhase.empty).Compose(context)
            return
        }

        let urlString = url.absoluteString
        // Coil does not automatically handle embedded jar URLs like jar:file:/data/app/…/base.apk!/showcase/module/Resources/swift-logo.png, so
        // we add a custom `SkipURLFetcher` fetcher that will handle loading the URL
        let requestSource: Any = urlString.hasPrefix("jar:") ? url : urlString
        let model = ImageRequest.Builder(LocalContext.current)
            .fetcherFactory(SkipURLFetcher.Factory())
            .data(requestSource)
            .size(Size.ORIGINAL)
            .build()
        SubcomposeAsyncImage(model: model, contentDescription: nil, loading: { _ in
            content(AsyncImagePhase.empty).Compose(context: context)
        }, success: { state in
            let image = Image(painter: self.painter, scale: scale)
            content(AsyncImagePhase.success(image)).Compose(context: context)
        }, error: { state in
            content(AsyncImagePhase.failure(ErrorException(cause: state.result.throwable))).Compose(context: context)
        })
    }
    #else
    public var body: some View {
        stubView()
    }
    #endif

    @ViewBuilder static func defaultPlaceholder() -> some View {
        #if SKIP
        Color.placeholder
        #else
        stubView()
        #endif
    }
}

public enum AsyncImagePhase : Sendable {
    case empty
    case success(Image)
    case failure(Error)

    public var image: Image? {
        switch self {
        case .success(let image):
            return image
        default:
            return nil
        }
    }

    public var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}

#if SKIP
import android.net.Uri
import android.webkit.MimeTypeMap
import coil.fetch.Fetcher
import coil.fetch.FetchResult
import coil.fetch.SourceResult
import coil.ImageLoader
import coil.decode.AssetMetadata
import coil.decode.DataSource
import coil.decode.ImageSource
import coil.request.Options
import okio.Source
import okio.__

/// A Coil fetcher that handles `skip.foundation.URL` instances for the `jar:` scheme.
internal class SkipURLFetcher : Fetcher {
    private let data: URL
    private let options: Options

    init(data: URL, options: Options) {
        self.data = data
        self.options = options
    }

    override func fetch() async -> FetchResult {
        return SourceResult(
            source: ImageSource(
                source: data.platformURL.openConnection().getInputStream().source().buffer(),
                context: options.context
            ),
            mimeType: MimeTypeMap.getSingleton().getMimeTypeFromExtension(MimeTypeMap.getFileExtensionFromUrl(data.absoluteString)),
            dataSource: DataSource.DISK
        )
    }

    class Factory : Fetcher.Factory<URL> {

        override func create(data: URL, options: Options, imageLoader: ImageLoader) -> Fetcher? {
            if (!isJarURL(data)) { return nil }
            return SkipURLFetcher(data: data, options: options)
        }
    }
}

internal func isJarURL(url: URL) -> Boolean {
    //return url.scheme == "jar"
    return url.absoluteString.hasPrefix("jar")
}

#endif


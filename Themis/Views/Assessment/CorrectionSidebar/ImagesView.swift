import MarkdownUI
import SwiftUI

struct ImagesView: View {
  private let content = """
    You can display an image by adding `!` and wrapping the alt text in `[ ]`.
    Then wrap the link for the image in parentheses `()`.

    ```
    ![This is an image](https://picsum.photos/id/91/400/300)
    ```

    ![This is an image](https://picsum.photos/id/91/400/300)

    ― Photo by Jennifer Trovato
    """

  private let assetContent = """
    You can configure a `Markdown` view to load images from the asset catalog.

    ```swift
    Markdown {
      "![This is an image](dog)"
    }
    .markdownImageProvider(.asset)
    ```

    ![This is an image](dog)
    
    Hallo!!
    
    ![This is an image](AppIcon)
    
    allo!!
    
    ![This is an image](TestPassedSymbol)
    
    loo
    
    ![This is an image](TestFailedSymbol)

    ― Photo by André Spieker
    """

  var body: some View {
    VStack {
      Markdown(self.assetContent)
            .markdownImageProvider(.asset)
    }
    .navigationTitle("Images")
  }
}

struct ImagesView_Previews: PreviewProvider {
  static var previews: some View {
    ImagesView()
  }
}

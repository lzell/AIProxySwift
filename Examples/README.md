## Example projects

### AIColorPalette

#### About

AIColorPalette generates a color palette from a photo in your camera roll. This project uses [AIProxy](https://www.aiproxy.pro) to secure your OpenAI key.

#### Features demonstrated

- Shows off new iOS 18 SwiftUI effects
- Calls the OpenAI chat completion endpoint
- Submits a photo as the chat completion request body
- Compels OpenAI to return valid JSON in the chat completion response

#### Minimum requirements

The minimum deployment target for this sample app is 18.0, as it uses beta UI effects.

You'll need:

- macOS Sonoma 14.5 or higher
- Xcode Beta 16.0 or higher

#### How to run with your own AIProxy settings

- Set the `AIPROXY_DEVICE_CHECK_BYPASS` environment variable in your Xcode build settings.
  Refer to the [README](https://github.com/lzell/AIProxySwift?tab=readme-ov-file#adding-this-package-as-a-dependency-to-your-xcode-project)
  for instructions on adding an env variable to your Xcode project.

- Replace the `partialKey` placeholder value in `AIColorPalette/AIProxyIntegration.swift` with the
  value provided to you in the AIProxy dashboard when you submit your OpenAI key

# About

Use this package to add [AIProxy](https://www.aiproxy.pro) support to your iOS and macOS apps.
AIProxy lets you depend on AI APIs safely without building your own backend. 
Five levels of security are applied to keep your API key secure and your AI bill predictable:

- Certificate pinning
- DeviceCheck verification
- Split key encryption
- Per user rate limits
- Per IP rate limits


# Installation


## How to add this package as a dependency to your Xcode project

1. From within your Xcode project, select `File > Add Package Dependencies`

   <img src="https://github.com/lzell/AIProxySwift/assets/35940/d44698a0-34e6-434b-b501-390254a14439" alt="Add package dependencies" width="420">

2. Punch `github.com/lzell/aiproxyswift` into the package URL bar, and select the 'main' branch
   as the dependency rule. Alternatively, you can choose specific releases if you'd like to have finer control of when your dependency gets updated.

   <img src="https://github.com/lzell/AIProxySwift/assets/35940/fd76b588-5e19-4d4d-9748-8db3fd64df8e" alt="Set package rule" width="720">

3. Add an `AIPROXY_DEVICE_CHECK_BYPASS` env variable to Xcode. This token is provided to you in the AIProxy
   developer dashboard, and is necessary for the iOS simulator to communicate with the AIProxy backend.
    - Type `cmd shift ,` to open up the "Edit Schemes" menu (or `Product > Scheme > Edit Scheme`)
    - Select `Run` in the sidebar
    - Select `Arguments` from the top nav
    - Add to the "Environment Variables" section an env variable with name
      `AIPROXY_DEVICE_CHECK_BYPASS` and value that we provided you in the AIProxy dashboard

      <img src="https://github.com/lzell/AIProxySwift/assets/35940/33ce2c0a-69ac-4beb-aefb-3d6c43b5e97a" alt="Add env variable" width="720">


The `AIPROXY_DEVICE_CHECK_BYPASS` is intended for the simulator only. Do not let it leak into
a distribution build of your app (including a TestFlight distribution). If you follow the steps above,
then the constant won't leak because env variables are not packaged into the app bundle.

See the FAQ for more details on the DeviceCheck bypass constant.


## How to update the package

- If you set the dependency rule to `main` in step 2 above, then you can ensure the package is
  up to date by right clicking on the package and selecting 'Update Package'
  
  <img src="https://github.com/lzell/AIProxySwift/assets/35940/aeee0ab2-362b-4995-b9ca-ff4e1dd04f47" alt="Update package version" width="720">


  

- If you selected a version-based rule, inspect the rule in the 'Package Dependencies' section
  of your project settings:

  <img src="https://github.com/lzell/AIProxySwift/assets/35940/ca788c4c-ac38-4d9d-bb4f-928a9487f6eb" alt="Update package rule" width="720">

  Once the rule is set to include the release version that you'd like to bring in, Xcode should
  update the package automatically. If it does not, right click on the package in the project
  tree and select 'Update Package'.


# Sample apps

Sample apps live in the `Examples` folder. As this repo grows, we will add sample apps demonstrating
supported functionality across various providers. Use these sample apps as starting points for your
own apps. See the [Examples README](https://github.com/lzell/AIProxySwift/blob/main/Examples/README.md)



# Example usage

### Get a non-streaming chat completion from OpenAI:


    import AIProxy

    let openAIService = AIProxy.openAIService(partialKey: "<the-partial-key-from-the-dashboard>")
    do {
        let response = try await openAIService.chatCompletionRequest(body: .init(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))]
        ))
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### Get a streaming chat completion from OpenAI:

    import AIProxy

    let openAIService = AIProxy.openAIService(partialKey: "<the-partial-key-from-the-dashboard>")
    let requestBody = OpenAIChatCompletionRequestBody(
        model: "gpt-4o",
        messages: [.init(role: "user", content: .text("hello world"))]
    )

    do {
        let stream = try await openAIService.streamingChatCompletionRequest(body: requestBody)
        for try await chunk in stream {
            print(chunk.choices.first?.delta.content ?? "")
        }
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### Send a multi-modal chat completion request to OpenAI:

On macOS, use `NSImage(named:)` in place of `UIImage(named:)`


    import AIProxy


    let openAIService = AIProxy.openAIService(partialKey: "<the-partial-key-from-the-dashboard>")
    guard let image = UIImage(named: "myImage") else {
        print("Could not find an image named 'myImage' in your app assets")
        return
    }

    guard let imageURL = AIProxy.openAIEncodedImage(image: image) else {
        print("Could not convert image to OpenAI's imageURL format")
        return
    }

    do {
        let response = try await openAIService.chatCompletionRequest(body: .init(
            model: "gpt-4o",
            messages: [
                .init(
                    role: "system",
                    content: .text("Tell me what you see")
                ),
                .init(
                    role: "user",
                    content: .parts(
                        [
                            .text("What do you see?"),
                            .imageURL(imageURL)
                        ]
                    )
                )
            ]
        ))
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to ensure OpenAI returns JSON as the chat message content

Use `responseFormat` *and* specify in the prompt that OpenAI should return JSON only:

    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "<the-partial-key-from-the-dashboard>"
    )
    do {
        let response = try await service.chatCompletionRequest(body: .init(
            model: "gpt-4o",
            messages: [
                .init(
                    role: "system",
                    content: .text("Return valid JSON only")
                ),
                .init(
                    role: "user",
                    content: .text("Return alice and bob in a list of names")
                )
            ],
            responseFormat: .type("json_object")
        ))
        print(response.choices.first?.message.content)
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }



### Specify your own `clientID` to annotate requests

If your app already has client or user IDs that you want to annotate AIProxy requests with,
pass a second argument to the provider's service initializer. For example:

    let openAIService = AIProxy.openAIService(
        partialKey: "<the-partial-key-from-the-dashboard>",
        clientID: "<your-id>"
    )

Requests that are made using `openAIService` will be annotated on the AIProxy backend, so that
when you view top users, or the timeline of requests, your client IDs will be familiar.

If you do not have existing client or user IDs, no problem! Leave the `clientID` argument
out, and we'll generate IDs for you. See `AIProxyIdentifier.swift` if you would like to see
ID generation specifics.



# Troubleshooting


## No such module 'AIProxy' error
Occassionally, Xcode fails to automatically add the AIProxy library to your target's dependency
list.  If you receive the `No such module 'AIProxy'` error, first ensure that you have added
the package to Xcode using the [Installation steps](https://github.com/lzell/AIProxySwift?tab=readme-ov-file#installation).
Next, select your project in the Project Navigator (`cmd-1`), select your target, and scroll to
the `Frameworks, Libraries, and Embedded Content` section. Tap on the plus icon:

<img src="https://github.com/lzell/AIProxySwift/assets/35940/438e2bbb-688c-49bc-aa2a-ea85806818d5" alt="Add library dependency" width="820">  

And add the AIProxy library:

<img src="https://github.com/lzell/AIProxySwift/assets/35940/f015a181-9591-435c-a37f-6fb0c8c5050c" alt="Select the AIProxy dependency" width="400">  


## macOS network sandbox

If you encounter the error

    networkd_settings_read_from_file Sandbox is preventing this process from reading networkd settings file at "/Library/Preferences/com.apple.networkd.plist", please add an exception.

Modify your macOS project settings by tapping on your project in the Xcode project tree, then
select `Signing & Capabilities` and enable `Outgoing Connections (client)`


## 'async' call in a function that does not support concurrency

If you use the snippets above and encounter the error

    'async' call in a function that does not support concurrency

it is because we assume you are in a structured concurrency context. If you encounter this
error, you can use the escape hatch of wrapping your snippet in a `Task {}`.


## Requests to AIProxy fail in iOS XCTest UI test cases

If you'd like to do UI testing and allow the test cases to execute real API requests, you must
set the `AIPROXY_DEVICE_CHECK_BYPASS` env variable in your test plan **and** forward the env
variable from the test case to the host simulator (Apple does not do this by default, which I
consider a bug). Here is how to set it up:

* Set the `AIPROXY_DEVICE_CHECK_BYPASS` env variable in your test environment:
  - Open the scheme editor at `Product > Scheme > Edit Scheme`
  - Select `Test`
  - Tap through to the test plan
  
    <img src="https://github.com/lzell/AIProxySwift/assets/35940/9a372244-f03e-4fe3-9361-ffc9d729b7d9" alt="Select test plan" width="720">  
    
  - Select `Configurations > Environment Variables`
    
    <img src="https://github.com/lzell/AIProxySwift/assets/35940/2e042957-2c40-4335-833d-70b2bf56c31a" alt="Select env variables" width="780">
    
  - Add the `AIPROXY_DEVICE_CHECK_BYPASS` env variable with your value  
  
    <img src="https://github.com/lzell/AIProxySwift/assets/35940/e466097c-1700-401d-add6-07c14dd26ab8" alt="Enter env variable value" width="720">

* **Important** Edit your test cases to forward on the env variable to the host simulator:

```swift
func testExample() throws {
    let app = XCUIApplication()
    app.launchEnvironment = [
        "AIPROXY_DEVICE_CHECK_BYPASS": ProcessInfo.processInfo.environment["AIPROXY_DEVICE_CHECK_BYPASS"]!
    ]
    app.launch()
}
```


# FAQ


## What is the `AIPROXY_DEVICE_CHECK_BYPASS` constant?

AIProxy uses Apple's [DeviceCheck](https://developer.apple.com/documentation/devicecheck) to ensure
that requests received by the backend originated from your app on a legitimate Apple device.
However, the iOS simulator cannot produce DeviceCheck tokens. Rather than requiring you to
constantly build and run on device during development, AIProxy provides a way to skip the
DeviceCheck integrity check. The token is intended for use by developers only. If an attacker gets
the token, they can make requests to your AIProxy project without including a DeviceCheck token, and
thus remove one level of protection.

## What is the `aiproxyPartialKey` constant?

This constant is intended to be **included** in the distributed version of your app. As the name implies, it is a
partial representation of your OpenAI key. Specifically, it is one half of an encrypted version of your key.
The other half resides on AIProxy's backend. As your app makes requests to AIProxy, the two encrypted parts
are paired, decrypted, and used to fulfill the request to OpenAI.


## Community contributions

Contributions are welcome! In order to contribute, we require that you grant
AIProxy an irrevocable license to use your contributions as we see fit.
Please read [CONTRIBUTIONS.md](https://github.com/lzell/AIProxySwift/blob/main/CONTRIBUTIONS.md) for details

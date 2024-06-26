## iOS and macOS clients for AIProxy

This is a young project. It includes a small client for OpenAI that routes all
requests through [AIProxy](https://www.aiproxy.pro). You would use this client to add AI to your apps
without building your own backend. Three levels of security are applied to keep
your API key secure and your AI bill predictable:

- Certificate pinning
- DeviceCheck verification
- Split key encryption


## Note to existing customers

If you previously used `AIProxy.swift` from our dashboard, or integrated with
SwiftOpenAI, you will find that we initialize the aiproxy service slightly
differently here. We no longer accept a `deviceCheckBypass` as an argument to
the initializer of the service. It was too easy to accidentally leak the constant.

Instead, you add the device check bypass as an environment variable. Please follow
the steps in the next section for adding an environment variable to your project.


## Adding this package as a dependency to your Xcode project

1. Open your Xcode project
2. Select `File > Add Package Dependencies`
3. Punch `github.com/lzell/aiproxyswift` into the package URL bar
4. Add an `AIPROXY_DEVICE_CHECK_BYPASS' env variable to Xcode. This token is provided to you in the AIProxy
   developer dashboard, and is necessary for the iOS simulator to communicate with the AIProxy backend.
    - Type `cmd shift ,` to open up the "Edit Schemes" menu.
    - Select `Run` in the sidebar
    - Select `Arguments` from the top nav
    - Add to the "Environment Variables" section (not the "Arguments Passed on Launch" section) an env
      variable with name `AIPROXY_DEVICE_CHECK_BYPASS` and value that we provided you in the AIProxy dashboard


The `AIPROXY_DEVICE_CHECK_BYPASS` is intended for the simulator only. Do not let it leak into
a distribution build of your app (including a TestFlight distribution). If you follow the steps above,
then the constant won't leak because env variables are not packaged into the app bundle.

See the FAQ for more details on the DeviceCheck bypass constant.


## Sample apps

Sample apps live in the `Examples` folder. As this repo grows, we will add sample apps demonstrating
supported functionality across various providers. Use these sample apps as starting points for your
own apps. See the [Examples README](https://github.com/lzell/AIProxySwift/blob/main/Examples/README.md)



## Example usage

### Get a chat completion from openai:


    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "<the-partial-key-from-the-dashboard>"
    )
    do {
        let response = try await openAIService.chatCompletionRequest(body: .init(
            model: "gpt-4o",
            messages: [.init(role: "system", content: .text("hello world"))]
        ))
        print(response.choices.first?.message.content)
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### Send a multi-modal chat completion request to openai:


    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "<the-partial-key-from-the-dashboard>"
    )
    let imageURL = // get a local URL of your image, see OpenAIServiceTests.swift for an example
    do {
        let response = try await service.chatCompletionRequest(body: .init(
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
        print(response.choices.first?.message.content)
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



## Troubleshooting

#### Async function context

If you use the snippets above and encounter the error

    'async' call in a function that does not support concurrency

it is because we assume you are in a structured concurrency context. If you encounter this
error, you can use the escape hatch of wrapping your snippet in a `Task {}`.


#### macOS network sandbox

If you encounter the error

    networkd_settings_read_from_file Sandbox is preventing this process from reading networkd settings file at "/Library/Preferences/com.apple.networkd.plist", please add an exception.

Modify your macOS project settings by tapping on your project in the Xcode project tree, then
select `Signing & Capabilities` and enable `Outgoing Connections (client)`


## FAQ


### What is the `AIPROXY_DEVICE_CHECK_BYPASS` constant?

AIProxy uses Apple's [DeviceCheck](https://developer.apple.com/documentation/devicecheck) to ensure
that requests received by the backend originated from your app on a legitimate Apple device.
However, the iOS simulator cannot produce DeviceCheck tokens. Rather than requiring you to
constantly build and run on device during development, AIProxy provides a way to skip the
DeviceCheck integrity check. The token is intended for use by developers only. If an attacker gets
the token, they can make requests to your AIProxy project without including a DeviceCheck token, and
thus remove one level of protection.

### What is the `aiproxyPartialKey` constant?

This constant is intended to be **included** in the distributed version of your app. As the name implies, it is a
partial representation of your OpenAI key. Specifically, it is one half of an encrypted version of your key.
The other half resides on AIProxy's backend. As your app makes requests to AIProxy, the two encrypted parts
are paired, decrypted, and used to fulfill the request to OpenAI.


## Community contributions

Contributions are welcome! In order to contribute, we require that you grant
AIProxy an irrevocable license to use your contributions as we see fit.
Please read [CONTRIBUTIONS.md](https://github.com/lzell/AIProxySwift/blob/main/CONTRIBUTIONS.md) for details

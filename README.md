## iOS and macOS clients for AIProxy

This is a young project. It includes a small client for OpenAI that routes all
requests through AIProxy. You would use this client to add AI to your apps
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
4. Add the device check bypass token to your Xcode project as an environment
   variable (you get the bypass token when you configure a project on aiproxy.pro)
    - Type `cmd shift ,` to open up the "Edit Schemes" menu.
    - Select `Run` in the sidebar
    - Select `Arguments` from the top nav
    - Add to the "Environment Variables" section (not the "Arguments Passed on
   Launch" section) an env variable with name `AIPROXY_DEVICE_CHECK_BYPASS` and
   value that we provided you in the AIProxy dashboard



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


### Troubleshooting

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


## Community contributions

Contributions are welcome! In order to contribute, we require that you grant
AIProxy an irrevocable license to use your contributions as we see fit.
Please read [CONTRIBUTIONS.md](https://github.com/lzell/AIProxySwift/blob/main/CONTRIBUTIONS.md) for details

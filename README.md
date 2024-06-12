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

Instead, you add the device check bypass as an environment variable. Here are the
steps:

1. Type `cmd shift ,` to open up the "Edit Schemes" menu.
2. Select `Run` in the sidebar
3. Select `Arguments` from the top nav
4. Add to the "Environment Variables" section (not the "Arguments Passed on
   Launch" section) an env variable with name `AIPROXY_DEVICE_CHECK_BYPASS` and
   value that we provided you in the AIProxy dashboard


## Example usage:

### Get a chat completion from a text prompt:


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


Note that you have to be in an async context for the above to work. If you are
not using structured concurrency, wrap the code above in a `Task`


### Get a chat completion that includes an image:


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


Note that you have to be in an async context for the above to work. If you are
not using structured concurrency, wrap the code above in a `Task`.

There are simple examples in `Tests/AIProxyTests/OpenAIServiceTests.swift` that you may take inspiration from.

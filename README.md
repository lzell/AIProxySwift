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


# Example usage

Along with the snippets below, which you can copy and paste into your Xcode project, we also
offer full demo apps to jump-start your development. Please see the [AIProxyBootstrap](https://github.com/lzell/AIProxyBootstrap) repo.

### Get a non-streaming chat completion from OpenAI:

    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let response = try await openAIService.chatCompletionRequest(body: .init(
            model: "gpt-4o",
            messages: [.system(content: .text("hello world"))]
        ))
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### Get a streaming chat completion from OpenAI:

    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    let requestBody = OpenAIChatCompletionRequestBody(
        model: "gpt-4o-mini",
        messages: [.user(content: .text("hello world"))]
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

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
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
                .system(
                    content: .text("Tell me what you see")
                ),
                .user(
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


### How to generate an image with DALLE

This snippet will print out the URL of an image generated with `dall-e-3`:

    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let requestBody = OpenAICreateImageRequestBody(
            prompt: "a skier",
            model: "dall-e-3"
        )
        let response = try await openAIService.createImageRequest(body: requestBody)
        print(response.data.first?.url ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to ensure OpenAI returns JSON as the chat message content

Use `responseFormat` *and* specify in the prompt that OpenAI should return JSON only:

    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [
                .system(content: .text("Return valid JSON only")),
                .user(content: .text("Return alice and bob in a list of names"))
            ],
            responseFormat: .jsonObject
        )
        let response = try await openAIService.chatCompletionRequest(body: requestBody)
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to use OpenAI structured outputs (JSON schemas) in a chat response

This example prompts chatGPT to construct a color palette and conform to a strict JSON schema
in its response:

    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let schema: [String: AIProxyJSONValue] = [
            "type": "object",
            "properties": [
                "colors": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "name": [
                                "type": "string",
                                "description": "A descriptive name to give the color"
                            ],
                            "hex_code": [
                                "type": "string",
                                "description": "The hex code of the color"
                            ]
                        ],
                        "required": ["name", "hex_code"],
                        "additionalProperties": false
                    ]
                ]
            ],
            "required": ["colors"],
            "additionalProperties": false
        ]
        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o",
            messages: [
                .system(content: .text("Return valid JSON only")),
                .user(content: .text("Return a peaches and cream color palette"))
            ],
            responseFormat: .jsonSchema(
                name: "palette_creator",
                description: "A list of colors that make up a color pallete",
                schema: schema,
                strict: true
            )
        )
        let response = try await openAIService.chatCompletionRequest(body: requestBody)
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to use OpenAI structured outputs (JSON schemas) in a tool call

This example is taken from the structured outputs announcement:
https://openai.com/index/introducing-structured-outputs-in-the-api/

It asks ChatGPT to call a function with the correct arguments to look up a business's unfulfilled orders:

    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let schema: [String: AIProxyJSONValue] = [
            "type": "object",
            "properties": [
                "location": [
                    "type": "string",
                    "description": "The city and state, e.g. San Francisco, CA"
                ],
                "unit": [
                  "type": "string",
                  "enum": ["celsius", "fahrenheit"],
                  "description": "The unit of temperature. If not specified in the prompt, always default to fahrenheit",
                  "default": "fahrenheit"
                ]
            ],
            "required": ["location", "unit"],
            "additionalProperties": false
        ]

        let requestBody = OpenAIChatCompletionRequestBody(
            model: "gpt-4o-2024-08-06",
            messages: [
                .user(content: .text("How cold is it today in SF?"))
            ],
            tools: [
                .function(
                    name: "get_weather",
                    description: "Call this when the user wants the weather",
                    parameters: schema,
                    strict: true)
            ]
        )

        let response = try await openAIService.chatCompletionRequest(body: requestBody)
        if let toolCall = response.choices.first?.message.toolCalls?.first {
            let functionName = toolCall.function.name
            let arguments = toolCall.function.arguments ?? [:]
            print("ChatGPT wants us to call function \(functionName) with arguments: \(arguments)")
        } else {
            print("Could not get function arguments")
        }

    } catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not make a tool call to OpenAI: \(error.localizedDescription)")
    }


### How to get word-level timestamps in an audio transcription

1. Record an audio file in quicktime and save it as "helloworld.m4a"
2. Add the audio file to your Xcode project. Make sure it's included in your target: select your audio file in the project tree, type `cmd-opt-0` to open the inspect panel, and view `Target Membership`
3. Run this snippet:

    ```
    import AIProxy

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let url = Bundle.main.url(forResource: "helloworld", withExtension: "m4a")!
        let requestBody = OpenAICreateTranscriptionRequestBody(
            file: try Data(contentsOf: url),
            model: "whisper-1",
            responseFormat: "verbose_json",
            timestampGranularities: [.word, .segment]
        )
        let response = try await openAIService.createTranscriptionRequest(body: requestBody)
        if let words = response.words {
            for word in words {
                print("\(word.word) from \(word.start) to \(word.end)")
            }
        }
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }
    ```


### How to send an Anthropic message request

    import AIProxy

    let anthropicService = AIProxy.anthropicService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let response = try await anthropicService.messageRequest(body: AnthropicMessageRequestBody(
            maxTokens: 1024,
            messages: [
                AnthropicInputMessage(content: [.text("hello world")], role: .user)
            ],
            model: "claude-3-5-sonnet-20240620"
        ))
        for content in response.content {
            switch content {
            case .text(let message):
                print("Claude sent a message: \(message)")
            case .toolUse(id: _, name: let toolName, input: let toolInput):
                print("Claude used a tool \(toolName) with input: \(toolInput)")
            }
        }
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to send an image to Anthropic

Use `UIImage` in place of `NSImage` for iOS apps:

    import AIProxy

    guard let image = NSImage(named: "marina") else {
        print("Could not find an image named 'marina' in your app assets")
        return
    }

    guard let jpegData = AIProxy.encodeImageAsJpeg(image: image, compressionQuality: 0.8) else {
        print("Could not convert image to jpeg")
        return
    }

    let anthropicService = AIProxy.anthropicService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let response = try await anthropicService.messageRequest(body: AnthropicMessageRequestBody(
            maxTokens: 1024,
            messages: [
                AnthropicInputMessage(content: [
                    .text("Provide a very short description of this image"),
                    .image(mediaType: .jpeg, data: jpegData.base64EncodedString())
                ], role: .user)
            ],
            model: "claude-3-5-sonnet-20240620"
        ))
        for content in response.content {
            switch content {
            case .text(let message):
                print("Claude sent a message: \(message)")
            case .toolUse(id: _, name: let toolName, input: let toolInput):
                print("Claude used a tool \(toolName) with input: \(toolInput)")
            }
        }
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to use the tools API with Anthropic

    import AIProxy

    let anthropicService = AIProxy.anthropicService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let requestBody = AnthropicMessageRequestBody(
            maxTokens: 1024,
            messages: [
                .init(
                    content: [.text("What is nvidia's stock price?")],
                    role: .user
                )
            ],
            model: "claude-3-5-sonnet-20240620",
            tools: [
                .init(
                    description: "Call this function when the user wants a stock symbol",
                    inputSchema: [
                        "type": "object",
                        "properties": [
                            "ticker": [
                                "type": "string",
                                "description": "The stock ticker symbol, e.g. AAPL for Apple Inc."
                            ]
                        ],
                        "required": ["ticker"]
                    ],
                    name: "get_stock_symbol"
                )
            ]
        )
        let response = try await anthropicService.messageRequest(body: requestBody)
        for content in response.content {
            switch content {
            case .text(let message):
                print("Claude sent a message: \(message)")
            case .toolUse(id: _, name: let toolName, input: let toolInput):
                print("Claude used a tool \(toolName) with input: \(toolInput)")
            }
        }
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to generate an image with Stability.ai

In the snippet below, replace NSImage with UIImage if you are building on iOS.
For a SwiftUI example, see [this gist](https://gist.github.com/lzell/a878b787f24cc0dd87a31f4dceccd092)

    import AIProxy

    let service = AIProxy.stabilityAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let body = StabilityAIUltraRequestBody(prompt: "Lighthouse on a cliff overlooking the ocean")
        let response = try await service.ultraRequest(body: body)
        let image = NSImage(data: response.imageData)
        // Do something with `image`
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print(error.localizedDescription)
    }


### How to create translations using DeepL

    import AIProxy

    let service = AIProxy.deepLService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let body = DeepLTranslateRequestBody(targetLang: "ES", text: ["hello world"])
        let response = try await service.translateRequest(body: body)
        // Do something with `response.translations`
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create translation: \(error.localizedDescription)")
    }


### How to create a non-streaming chat completion with TogetherAI

See the [TogetherAI model list](https://docs.together.ai/docs/chat-models) for available
options to pass as the `model` argument:

    import AIProxy

    let togetherAIService = AIProxy.togetherAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let requestBody = TogetherAIChatCompletionRequestBody(
            messages: [TogetherAIMessage(content: "Hello world", role: .user)],
            model: "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo"
        )
        let response = try await togetherAIService.chatCompletionRequest(body: requestBody)
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create TogetherAI chat completion: \(error.localizedDescription)")
    }


### How to create a streaming chat completion with TogetherAI

See the [TogetherAI model list](https://docs.together.ai/docs/chat-models) for available
options to pass as the `model` argument:

    import AIProxy

    let togetherAIService = AIProxy.togetherAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let requestBody = TogetherAIChatCompletionRequestBody(
            messages: [TogetherAIMessage(content: "Hello world", role: .user)],
            model: "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo"
        )
        let stream = try await togetherAIService.streamingChatCompletionRequest(body: requestBody)
        for try await chunk in stream {
            print(chunk.choices.first?.delta.content ?? "")
        }
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create TogetherAI streaming chat completion: \(error.localizedDescription)")
    }


### How to create a JSON response with TogetherAI

JSON mode is handy for enforcing that the model returns JSON in a structure that your
application expects. You specify the contract using `schema` below. Note that only some models
support JSON mode. See [this guide](https://docs.together.ai/docs/json-mode) for a list.

    import AIProxy

    let togetherAIService = AIProxy.togetherAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let schema: [String: AIProxyJSONValue] = [
            "type": "object",
            "properties": [
                "colors": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "name": [
                                "type": "string",
                                "description": "A descriptive name to give the color"
                            ],
                            "hex_code": [
                                "type": "string",
                                "description": "The hex code of the color"
                            ]
                        ],
                        "required": ["name", "hex_code"],
                        "additionalProperties": false
                    ]
                ]
            ],
            "required": ["colors"],
            "additionalProperties": false
        ]
        let requestBody = TogetherAIChatCompletionRequestBody(
            messages: [
                TogetherAIMessage(
                    content: "You are a helpful assistant that answers in JSON",
                    role: .system
                ),
                TogetherAIMessage(
                    content: "Create a peaches and cream color palette",
                    role: .user
                )
            ],
            model: "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo",
            responseFormat: .json(schema: schema)
        )
        let response = try await togetherAIService.chatCompletionRequest(body: requestBody)
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create TogetherAI JSON chat completion: \(error.localizedDescription)")
    }


### How to make a tool call request with Llama and TogetherAI

This example is a Swift port of [this guide](https://docs.together.ai/docs/llama-3-function-calling):

    import AIProxy

    let togetherAIService = AIProxy.togetherAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let function = TogetherAIFunction(
            description: "Call this when the user wants the weather",
            name: "get_weather",
            parameters: [
                "type": "object",
                "properties": [
                    "location": [
                        "type": "string",
                        "description": "The city and state, e.g. San Francisco, CA",
                    ],
                    "num_days": [
                        "type": "integer",
                        "description": "The number of days to get the forecast for",
                    ],
                ],
                "required": ["location", "num_days"],
            ]
        )

        let toolPrompt = """
        You have access to the following functions:

        Use the function '\(function.name)' to '\(function.description)':
        \(try function.serialize())

        If you choose to call a function ONLY reply in the following format with no prefix or suffix:

        <function=example_function_name>{{\"example_name\": \"example_value\"}}</function>

        Reminder:
        - Function calls MUST follow the specified format, start with <function= and end with </function>
        - Required parameters MUST be specified
        - Only call one function at a time
        - Put the entire function call reply on one line
        - If there is no function call available, answer the question like normal with your current knowledge and do not tell the user about function calls

        """

        let requestBody = TogetherAIChatCompletionRequestBody(
            messages: [
                TogetherAIMessage(
                    content: toolPrompt,
                    role: .system
                ),
                TogetherAIMessage(
                    content: "What's the weather like in Tokyo over the next few days?",
                    role: .user
                )
            ],
            model: "meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo",
            temperature: 0,
            tools: [
                TogetherAITool(function: function)
            ]
        )
        let response = try await togetherAIService.chatCompletionRequest(body: requestBody)
        print(response.choices.first?.message.content ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create TogetherAI llama 3.1 tool completion: \(error.localizedDescription)")
    }


### How to generate a Flux-Schnell image by Black Forest Labs, using Replicate

    import AIProxy

    let replicateService = AIProxy.replicateService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let input = ReplicateFluxSchnellInputSchema(
            prompt: "Monument valley, Utah"
        )
        let output = try await replicateService.createFluxSchnellImage(
            input: input
        )
        print("Done creating Flux-Schnell image: ", output.first ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create Flux-Schnell image: \(error.localizedDescription)")
    }


See the full range of controls for generating an image by viewing `ReplicateFluxSchnellInputSchema.swift`


### How to generate a Flux-Dev image by Black Forest Labs, using Replicate

    let replicateService = AIProxy.replicateService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let input = ReplicateFluxDevInputSchema(
            prompt: "Monument valley, Utah. High res"
        )
        let output = try await replicateService.createFluxDevImage(
            input: input
        )
        print("Done creating Flux-Dev image: ", output.first ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create Flux-Dev image: \(error.localizedDescription)")
    }


See the full range of controls for generating an image by viewing `ReplicateFluxDevInputSchema.swift`


### How to generate a Flux-Pro image by Black Forest Labs, using Replicate

    import AIProxy

    let replicateService = AIProxy.replicateService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let input = ReplicateFluxProInputSchema(
            prompt: "Monument valley, Utah. High res"
        )
        let output = try await replicateService.createFluxProImage(
            input: input
        )
        print("Done creating Flux-Pro image: ", output.first ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create Flux-Pro image: \(error.localizedDescription)")
    }


See the full range of controls for generating an image by viewing `ReplicateFluxProInputSchema.swift`


### How to generate an SDXL image by StabilityAI, using Replicate

    import AIProxy

    let replicateService = AIProxy.replicateService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let input = ReplicateSDXLInputSchema(
            prompt: "Monument valley, Utah"
        )
        let output = try await replicateService.createSDXLImage(
            input: input
        )
        print("Done creating SDXL image: ", output.first ?? "")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create SDXL image: \(error.localizedDescription)")
    }

See the full range of controls for generating an image by viewing `ReplicateSDXLInputSchema.swift`


### How to call your own fine-tuned models on Replicate.

1. Generate the Encodable representation of your input schema. You can use input schemas in
   this library as inspiration. Take a look at `ReplicateFluxProInputSchema.swift` as
   inspiration. Find the schema format that you should conform to using replicate's web
   dashboard and tapping through `Your Model > API > Schema > Input Schema`

2. Generate the Decodable representation of your output schema. The output schema is defined on
   replicate's site at `Your Model > API > Schema > Output Schema`. For simple cases, a typealias
   will do (for example, if the output schema is just a string or an array of strings). Look at
   `ReplicateFluxOutputSchema.swift` for inspiration. If you need help doing this, please reach out.

3. Call the `createPrediction` method, followed by `pollForPredictionOutput` method. Note that
   you'll need to change `YourInputSchema`, `YourOutputSchema` and `your-model-version` in this
   snippet:


    ```
    import AIProxy

    let replicateService = AIProxy.replicateService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )

    do {
        let input = YourInputSchema(
            prompt: "Monument valley, Utah"
        )

        let predictionResponse = try await replicateService.createPrediction(
            version: "your-model-version",
            input: input,
            output: ReplicatePredictionResponseBody<YourOutputSchema>.self
        )
        let predictionOutput: YourOutputSchema = try await replicateService.pollForPredictionOutput(
            predictionResponse: predictionResponse,
            pollAttempts: 30
        )
        print("Done creating predictionOutput")
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create replicate prediction: \(error.localizedDescription)")
    }
    ```

### How to use ElevenLabs for text-to-speech

    import AIProxy

    let elevenLabsService = AIProxy.elevenLabsService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard"
    )
    do {
        let body = ElevenLabsTTSRequestBody(
            text: "Hello world"
        )
        let mpegData = try await elevenLabsService.ttsRequest(
            voiceID: "EXAVITQu4vr4xnSDxMaL",
            body: body
        )

        // Do not use a local `let` or `var` for AVAudioPlayer.
        // You need the lifecycle of the player to live beyond the scope of this function.
        // Instead, use file scope or set the player as a member of a reference type with long life.
        // For example, at the top of this file you may define:
        //
        //   fileprivate var audioPlayer: AVAudioPlayer? = nil
        //
        // And then use the code below to play the TTS result:
        audioPlayer = try AVAudioPlayer(data: mpegData)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }  catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
        print("Received non-200 status code: \(statusCode) with response body: \(responseBody)")
    } catch {
        print("Could not create ElevenLabs TTS audio: \(error.localizedDescription)")
    }

- See the full range of TTS controls by viewing `ElevenLabsTTSRequestBody.swift`.
- See https://api.elevenlabs.io/v1/voices for the IDs that you can pass to `voiceID`.


### How to fetch the weather with OpenMeteo

This pattern is slightly different than the others, because OpenMeteo has an official lib that
we'd like to rely on. To run the snippet below, you'll need to add AIProxySwift and
OpenMeteoSDK to your Xcode project. Add OpenMeteoSDK:

- In Xcode, go to `File > Add Package Dependences`
- Enter the package URL `https://github.com/open-meteo/sdk`
- Choose your dependency rule (e.g. the `main` branch for the most up-to-date package)

Next, use AIProxySwift's core functionality to get a URLRequest and URLSession, and pass those
into the OpenMeteoSDK:


    import AIProxy
    import OpenMeteoSdk

    do {
        let request = try await AIProxy.request(
            partialKey: "partial-key-from-your-aiproxy-developer-dashboard",
            serviceURL: "service-url-from-your-aiproxy-developer-dashboard",
            proxyPath: "/v1/forecast?latitude=52.52&longitude=13.41&hourly=temperature_2m&format=flatbuffers"
        )
        let session = AIProxy.session()
        let responses = try await WeatherApiResponse.fetch(request: request, session: session)
        // Do something with `responses`. For a usage example, follow these instructions:
        // 1. Navigate to https://open-meteo.com/en/docs
        // 2. Scroll to the 'API response' section
        // 3. Tap on Swift
        // 4. Scroll to 'Usage'
        print(responses)
    } catch {
        print("Could not fetch the weather: \(error.localizedDescription)")
    }


### Specify your own `clientID` to annotate requests

If your app already has client or user IDs that you want to annotate AIProxy requests with,
pass a second argument to the provider's service initializer. For example:

    let openAIService = AIProxy.openAIService(
        partialKey: "partial-key-from-your-developer-dashboard",
        serviceURL: "service-url-from-your-developer-dashboard",
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


## Contribution style guidelines

- In codable representations, fields that are required by the API should be above fields that
  are optional. Within the two groups (required and optional) all fields should be
  alphabetically ordered.

- Decodables should all have optional properties. Why? We don't want to fail decoding in live
  apps if the provider changes something out from under us (which can happen purposefully due
  to deprecations, or by accident due to bad deploys). If we use non-optionals in decodable
  definitions, then a provider removing a field, changing the type of a field, or removing an
  enum case would cause decoding to fail. You may think this isn't too bad, since the
  JSONDecoder throws anyway, and therefore client code will already be wrapped in a do/catch.
  However, we always want to give the best chance that decodable succeeds _for the properties
  that the client actually uses_. That is, if the provider changes out the enum case of a
  property unused by the client, we want the client application to continue functioning
  correctly, not to throw an error and enter the catch branch of the client's call site.

- When a request or response object is deeply nested by the API provider, create nested structs
  in the same namespace as the top level object. This lib started with a flat namespace, so
  some structs do not follow this pattern. Going forward, though, nesting is preferred to flat.
  A flat namespace leads to long struct names to avoid collision between providers. Use this
  instead:

    ```
    // An example provider response
    public struct ProviderResponseBody: Decodable {

        // An examples status
        public let status: Status?

        // ... other fields ...
    }

    extension ProviderResponseBody {
        public enum Status: String, Decodable {
            case succeeded
            case failed
            case canceled
        }
    }
    ```

  This pattern avoids collisions, works well with Xcode's click to jump-to-definition, and
  improves source understanding for folks that use `ctrl-6` to navigate through a file.

- If you are implementing an API contract that could reuse a provider's nested structure, and
  it's reasonable to suppose that the two objects will change together, then pull the nested
  struct into its own file and give it a longer prefix. The example above would become:

    ```
    // ProviderResponseBody.swift
    public struct ProviderResponseBody: Decodable {

        // An examples status
        public let status: ProviderStatus?

        // ... other fields ...
    }

    // ProviderStatus.swift
    public enum ProviderStatus: String, Decodable {
        case succeeded
        case failed
        case canceled
    }
    ```

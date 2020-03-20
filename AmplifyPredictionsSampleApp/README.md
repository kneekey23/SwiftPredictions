# Predictions

AWS Amplify Predictions category for iOS provides a way to use machine learning in your app without any machine learning expertise. The Predictions category comes with built-in support for offline usage supported by Apple's CoreML Vision framework. With the CoreML Vision framework, we are able to support both offline and online use cases with automatic switching between the two unless indicated otherwise. In addition to providing automatic network support per device, we also provide a union of both the cloud models as well as the offline models to provide you the most accurate results for each of the use cases Apple's CoreML Vision Framework supports. An asterisk below indicates the use case is supported by CoreML and a merged accurate result will be returned if the device is online. Some supported use cases include:

* Translating text from one language to another
* Converting text to speech
* Text recognition from image *
* Entities recognition *
* Label real world objects *
* Interpretation of text *

Ensure you have [installed and configured the Amplify CLI and library](https://aws-amplify.github.io/docs/)


### Automated Configuration

Amplify CLI helps you to create and the appropriate IAM permissions to hit the AWS machine learning API's. As part of the automated setup, the CLI will help you build resources that leverage the following AWS services: [Amazon Translate](https://aws.amazon.com/translate), [Amazon Polly](https://aws.amazon.com/polly), [Amazon Textract](https://aws.amazon.com/textract), [Amazon Rekognition](https://aws.amazon.com/rekognition), [Amazon Comprehend](https://aws.amazon.com/comprehend). In addition to those services, we also support offline functionality and improved responses between online/offline models provided by Apple's CoreML [Vision Framework](https://developer.apple.com/documentation/vision).


##### Create Your Backend with the CLI

To create a project with the Predictions category, run the following command:

1. Run `amplify init` and choose `ios` for the type of app you're building

2. Add auth `amplify add auth` and choose `Default configuration`, allow users to sign in with `Email` and do not configure `advanced settings`

3. Add predictions `amplify add predictions` 
    * choose `Convert (translate text, text to speech), Identify (labels, text, celebs, etc.), or Interpret (language characteristics, sentiment, etc)`
    * Who should have access: `Auth and guest users`

4. Run `amplify push`to create the resources in the cloud.

When your backend is successfully updated, add `amplifyconfiguration.json` and `awsconfiguration.json` to your project using Xcode. Your new configuration file `awsconfiguration.json` will contain your default project `region` value as well as any necessary configuration options for each predictions method (i.e. target language and source language for translate, etc)


### Manual Configuration

If you have already created the resources in the cloud and would like to take advantage of those existing resources but still use the Amplify library in swift, please follow the directions below:

Create the file `amplifyconfiguration.json`
```
touch amplifyconfiguration.json
``` 

Copy the contents over and update the values for the specific predictions method you are looking to use
```
{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "Storage": {
        "plugins": {
            "awsPredictionsPlugin": { 
                "defaultRegion": "us-west-2",
                 "identify": {
                    "identifyText": {
                        "format": "ALL",
                        "region": "us-west-2",
                        "defaultNetworkPolicy": "auto"
                    },
                    "identifyEntities": {
                        "maxEntities": "0",
                        "celebrityDetectionEnabled": "true",
                        "region": "us-west-2",
                        "defaultNetworkPolicy": "auto"
                    },
                    "identifyLabels": {
                        "region": "us-west-2",
                        "type": "LABELS",
                        "defaultNetworkPolicy": "auto"
                    }
                },
                "convert": {
                    "translateText": {
                        "targetLang": "zh",
                        "sourceLang": "en",
                        "region": "us-west-2",
                        "defaultNetworkPolicy": "auto"
                    },
                    "speechGenerator": {
                        "voice": "Salli",
                        "language": "en-US",
                        "region": "us-west-2",
                        "defaultNetworkPolicy": "auto"
                    }
                },
                "interpret": {
                    "interpretText": {
                        "region": "us-west-2",
                        "defaultNetworkPolicy": "auto"
                    }
                }
            }
        }
    }
}
```
Add both the `amplifyconfiguration.json` and the `awsconfiguration.json` to your project using XCode.

### Connect to Your Backend

Use the following steps to add file storage backend services to your app.

1. Add the dependencies to the `Podfile`:

    ```ruby

    target :'YOUR-APP-NAME' do
        use_frameworks!

        pod 'Amplify', '~> 1.0.0'
        pod 'AmplifyPlugins/AWSPluginsCore', '~> 1.0.0'  # pod 'AWSPluginsCore', '~> 1.0.0' 
        pod 'AmplifyPlugins/AWSPredictionsPlugin', '~> 1.0.0'
        pod 'AWSMobileClient', '~> 2.12.0'
    end
    ```

Run `pod install --repo-update` before you continue.

2. Add the following code to your AppDelegate:

    ```swift
    import Amplify
    import AWSMobileClient
    import AmplifyPlugins

    // Inside  AppDelegate's application method
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AWSMobileClient.default().initialize { (userState, error) in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            guard let userState = userState else {
                print("userState is unexpectedly empty initializing AWSMobileClient")
                return
            }

            print("AWSMobileClient initialized, userstate: \(userState)")
        }

        let predictionsPlugin = AWSPredictionsPlugin()
        try! Amplify.add(plugin: predictionsPlugin)
        try! Amplify.configure()
        print("Amplify initialized")

        window = UIWindow()
        window?.rootViewController  = MainTabBarController()
        return true
    }
    ```

### Identify Labels

If you have set up your app correctly using the CLI and AppDelegate configuration above, you can identify labels in your app like so:

```swift
    func detectLabels(_ image:URL) {
        //for offline calls only to coreml models replace options in the call below with the below instantiation of it
        // let options = PredictionsIdentifyRequest.Options(defaultNetworkPolicy: .offline, pluginOptions: nil)
        _ = Amplify.Predictions.identify(type: .detectLabels(.labels), image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            
            switch event {
            case .completed(let result):
                let data = result as! IdentifyLabelsResult
                print(data.labels)
                //use the labels in your app as you like or display them 
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }

    //to identify labels with unsafe content
        func detectLabels(_ image:URL) {
        _ = Amplify.Predictions.identify(type: .detectLabels(.all), image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            
            switch event {
            case .completed(let result):
                let data = result as! IdentifyLabelsResult
                print(data.labels)
                //use the labels in your app as you like or display them 
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
```

### Identify Celebrities

``` swift
    func detectCelebs(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectCelebrity, image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyCelebritiesResult
                self.celebName = data.celebrities[0].metadata.name
                print(result)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
```

### Identify Entities

In order to match entities from a pre-created [Amazon Rekognition Collection](https://docs.aws.amazon.com/rekognition/latest/dg/collections.html), make sure there is a `collectionId` set in your `amplifyconfiguration.json` file. If there is no `collectionId` set in the `amplifyconfiguration.json` file, then this call will just detect entities in general with facial features, landmarks, etc. Bounding boxes for entities are returned as ratios so make sure if you would like to place the bounding box of your entity on an image that you multiple the x by the width of the image, the y by the width of the image, and both height and width ratios by the image's respective height and width.

``` swift
    func detectEntities(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectEntities, image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyEntityMatchesResult
                print(data.entities)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
```
If you would like to only detect entities and you do not have a collection of existing entities to match entities to, the call will be similar but the result is mapped to `IdentifyEntitiesResult` instead of the `IdentifyEntityMatchesResult`.

``` swift
    func detectEntities(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectEntities, image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyEntitiesResult
                print(data.entities)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
```


### Identify Text

#### Detecting Text in an Image
Amplify will make calls to both Amazon Textract and Rekognition depending on the type of text you are looking to identify (i.e. image or document). If you are detecting text from an image you would send in `.plain` as your text format as shown below. Similiarly, you can obtain `.offline` functionality or get combined results with AWS services for better results with the `.plain` text format selected. Bounding boxes for text are returned as ratios so make sure if you would like to place your bounding box on an image that you multiple the x by the width of the image, the y by the width of the image, and both height and width ratios by the image's respective height and width. Additionally, because Rekognition places (0,0) at the top left and CoreML places (0,0) at the bottom left, we have flipped the y axis of the CoreML bounding box for you since iOS starts (0,0) from the top left.

``` swift
    func detectText(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectText(.plain), image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyTextResult
                print(data)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
```

#### Detecting Text in a Document
Sending in `.form` or `.table` or `.all` will do document analysis as well as text dectection to detect tables and forms in a document. See below for an example with `.form`.

```swift 
    func detectText(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectText(.form), image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyDocumentTextResult
                print(data)
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
```

### Convert Text to Speech

Here is an example of converting text to speech. In order to override any choices you made while adding this resource using the Amplify CLI, you can pass in a voice in the options object as shown below.

``` swift
    func textToSpeech(text: String) {
        let options = PredictionsTextToSpeechRequest.Options(voiceType: .englishFemaleIvy, pluginOptions: nil)
     
        _ = Amplify.Predictions.convert(textToSpeech: text, options: options, listener: { (event) in
            
            switch event {
            case .completed(let result):
                print(result.audioData)
                self.audioData = result.audioData
                let player = try? AVAudioPlayer(data: result.audioData)
                player?.play()
            default:
                print("")
                
                
            }
        })
    }
```

### Convert - Translate Text

Here is an example of translating text. In order to override any choices you made in regards to target or source languages while adding this resource using the Amplify CLI, you can pass in them in directly as parameters as shown below.

``` swift
    func translateText(text:String) {
        _ = Amplify.Predictions.convert(textToTranslate: text,
                                        language: .english, 
                                        targetLanguage: .italian,
                                        options: PredictionsTranslateTextRequest.Options(),
                                        listener: { (event) in
                                            switch event {
                                            case .completed(let result):
                                                print(result.text)
                                            default:
                                                print("")
                                            }
                                        })
    }
```

### Interpret

Here is an example of sending text for interpretation such as sentiment analysis or natural language characteristics. 

```swift
    func interpret(text: String) {
        
        _ = Amplify.Predictions.interpret(text: text, options: PredictionsInterpretRequest.Options(), listener: { (event) in
               
               switch event {
               case .completed(let result):
                print(result)
               case .failed(let error):
                print(error)
               default:
                break
            }
           })
    }
```

### Escape Hatch

For any of the AWS services behind predictions, you can use the SDK object to get access to any methods we are not calling on your behalf by using the Escape Hatch like so:

```swift
let rekognitionService = Amplify.Predictions.getEscapeHatch(key: .rekognition) as! AWSRekognition
let request = rekognitionService.AWSRekognitionCreateCollectionRequest()
rekognitionService.createCollection(request)
```



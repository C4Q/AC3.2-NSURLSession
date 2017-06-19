### AC3.2 `NSURLSession / URLSession`
---

### Readings:
1. [`URLSession` - Apple](https://developer.apple.com/reference/foundation/urlsession) (just the "Overview section for now")
2. [Move from NSURLConnection to Session - Objc.io](https://www.objc.io/issues/5-ios7/from-nsurlconnection-to-nsurlsession/)
3. [Fundamentals of Callbacks for Swift Developers](https://www.andrewcbancroft.com/2016/02/15/fundamentals-of-callbacks-for-swift-developers/)
5. [Concurrency - Objc.io](https://www.objc.io/issues/2-concurrency/concurrency-apis-and-pitfalls/)
6. [Concurrency’s relation to Async Network requests (scroll down)](https://www.objc.io/issues/2-concurrency/common-background-practices/)
8. [Singletons in Swift - Thomas Hanning](http://www.thomashanning.com/singletons-in-swift/)

#### Singletons (Optional):
1. [Singletons - That Thing in Swift](https://thatthinginswift.com/singletons/)
2. [The Right Way to Write a Singleton - krakendev](http://krakendev.io/blog/the-right-way-to-write-a-singleton) (gives a nice short history of writing singletons in objc and swift. then shows you how/why they are truly "single". This blog in general is a really good resource worth bookmarking)

#### Advandced:
1. [Great talk on networking - Objc.io](https://talk.objc.io/episodes/S01E01-networking) (a bit advanced! uses flatmap, generics, computed properties and closure as properties) 
2. [Concurrency - Wiki](https://en.wikipedia.org/wiki/Concurrency_%28computer_science%29)

### Reference:
2. [`URL` - Apple](https://developer.apple.com/reference/foundation/url) 
4. [`JSONSerialization` - Apple](https://developer.apple.com/reference/foundation/jsonserialization)

### Resources:
1. [`myjson` - simple JSON hosting](http://myjson.com/)
2. [`JSONlint` - json format validation](http://jsonlint.com/)

---
### 0. Goals 

  - Understanding that `URL` truly is "universal" as it can refer to a file on your local machine, or a web URL
  - Handling `json` data from web requests is exactly like dealing with a local `dictionary/json`
  - Reusuability of code makes building something up to the point much easier as we can reuse the same parsing function from the prior lesson here. 

---
### 1. Getting InstaCats Locally

#### Focusing on the MVC Pattern

In MVC a (view) controller is only meant to coordinate data from the model and use that to update its views. In the first part of this lesson ([AC3.2-NSURL](https://github.com/C4Q/AC3.2-NSURL)), we put all of our code inside of our main view controller class. This lesson begins with that same base code, but we're going to refactor it so that we follow MVC principles. 

> Instructions: Follow the steps below in order to refactor your code. Make sure that your tests still pass after you've made your changes.

1. Create a separate `InstaCat.swift` file, and move the code for the `InstaCat` model there
2. Create a 
2. Create another file `InstaCatParser.swift` which will be tasked with taking a `URL` and parsing out `[InstaCat]`
3. Add the following template and fill out your functions using the code you wrote for `NSURL`

```swift
class InstaCatParser {
    init(){}
    
    // get an URL from String
    func getResourceURL(from fileName: String) -> URL? {
        
        return nil
    }
    
    // get Data from file located at URL
    func getData(from url: URL) -> Data? {
        
        return nil
    }
    
    // parse Data into InstaCats
    func parseInstaCats(from data: Data) -> [InstaCat]? {
        
        return nil
    }
}
```

#### Exercises

1. The point of the `InstaCatParser` is that it is going to handle all parsing of `InstaCats`. Create a single function called `func parseCats(from: String) -> [InstaCat]?` that calls the other three functions at once. This will be a convenience function to get us from a `String` representation of a file URL all the way to our desired `[InstaCat]`
2. Can you think of a way to ensure that only `parseCats(from:)` can ever be called? Why would this be advantageous to use?
3. Rewrite the code inside of `InstaCatTableViewController.viewDidLoad` to make use of `parseCats(from:)`

#### Advanced

1. Adjust the `InstaCatParser` to use a singleton. Future calls to the parser should then look like `InstaCatParser.shared.<function>`
  - Update your code in `InstaCatTableViewController.viewDidLoad` and elsewhere to work with this singleton.
 
> #### *Review*: The Singleton
> The goal of a singleton is that there only is ever one of them that exists in the lifetime of your app. Singletons work well for managing data in simple apps, but can cause problems in more complex situations.


---
### 2. The Internet and the Universality of URLs

Start out by adding the following line to the top of your `InstaCatTableViewController`:

```swift
  let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
```

(Plug in the URL into your browser too, just to see what comes up)

> Note: If the above URL isn't working, use: `https://raw.githubusercontent.com/C4Q/AC3.2-NSURLSession/master/Resources/JSON/instacat.json`

A fundamental principal in computer systems architecture is that the *"internet"* is just a lot of interconnected computers. Every image you've ever viewed, every video you've ever watched, and every website you've visited *are files that live on someone else's computer*, that you were accessing with your own. 

That's why when you plug in that previous URL into a browser, you're seeing exactly what you would see in a file called `254uw.json` if it lived on your computer. A URL describes where a file is, whether that's on your computer or on someone else's on the internet. In this case, there is a service called **myjson** that hosts json files that you create. The one we're looking at is one that I made using the exact same data/file as `InstaCat.json`

> In fact, if you located the `InstaCat.json` file that lives on your computer and dragged it into your browser window, the address bar would change to the URL of the file's local address, and you'd see the same data. The url would look something like `file:///Users/<your_user>/<path>/<to>/AC3.2-NSURLSession/Resources/JSON/instacat.json`. Notice how it says `file://` instead of `http://`!




> ***************************************************************************************************************
To locate files in our application's bundle we used `Bundle.main` to query for the data at a **local** `URL`. 

To locate a file on the internet, we need to use `URLSession` to query for the data at a **remote** `URL`. 
> ***************************************************************************************************************





---
### 3. Getting `InstaCats` from the Web

#### Making a `URLRequest` with `URLSession` 

What actually happens when you entered that myJson `URL` into your browser? 

Your browser sends what's known as a `GET` *request* to `https://api.myjson.com`. A `GET` request indicates that you're looking to **get** something from the `URL` you're requesting. The `GET` request we send contains more specific information: because we're interested in *getting* a specific set of json, we pass in two more path components: `/bins` and `/254uw`. If the request can be fulfilled by the receiving website, a response is returned corresponding to either the data we were looking for or an error describing what went wrong with the request. 

Let's take a look at how we can make a request to `api.myjson.com`:

To our `InstaCatTableViewController`, add 

```swift
    func getInstaCats(from apiEndpoint: String) -> [InstaCat]? {
      if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
  
      }

    }
```

Every web request begins with a `URLSession`, which gets instantiated with a specified `URLSessionConfiguration`. For our purposes, we will only ever use `URLSessionConfiguration.default`. 

> Note: Connecting to sites in order to send or receive data is known broadly as a *session*, which is why the class that manages *making requests* and *receiving responses* is called `URLSession`. 

```swift
func getInstaCats(from apiEndpoint: String) -> [InstaCat]? {
  if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {

    // 1. URLSession/Configuration
    let session = URLSession(configuration: URLSessionConfiguration.default)
  }
  
}
```


We then use the `dataTask(with:)` method of `URLSession` to initiate our request

```swift
func getInstaCats(from apiEndpoint: String) -> [InstaCat]? {
  if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
  
    // 1. URLSession/Configuration
    let session = URLSession(configuration: URLSessionConfiguration.default)
  
    // 2. dataTaskWithURL
    session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
    
    }
  }
}
```

>  Why all the optionals in `dataTask(with:)`? Well, you might not get `Data` back if the request is bad, you might not get a response if the internet is down, or you might not get an `Error` is everything goes right.


Best practices says to check for errors first

```swift
func getInstaCats(from apiEndpoint: String) -> [InstaCat]? {
  if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
  
    // 1. URLSession/Configuration
    let session = URLSession(configuration: URLSessionConfiguration.default)
  
    // 2. dataTaskWithURL
    session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
    
      // 3. check for errors right away
        if error != nil {
          print("Error encountered!: \(error!)")
        }
    }
  }
}
```

At this point, we could check to see if we have any data being returned and print it out...

```swift
func getInstaCats(from apiEndpoint: String) -> [InstaCat]? {
  if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
  
    // 1. URLSession/Configuration
    let session = URLSession(configuration: URLSessionConfiguration.default)
  
    // 2. dataTaskWithURL
    session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
    
      // 3. check for errors right away
      if error != nil {
        print("Error encountered!: \(error!)")
      }
    
      // 4. printing out the data
      if let validData: Data = data {
        print(validData) // not of much use other than to tell us that data does exist
      }
    }
  
  // 4a. ALSO THIS!
  }.resume()
}
```

You're almost always going to forget to add `.resume()` at first and until you call it, the `dataTask` won't actually execute. 

Anyhow that doesn't give us much information as the data is still in its raw encoded form. Now, in theory the `Data` we're getting back is *exactly* the same at if we were accessing the data from `InstaCat.json`. soo... 

```swift
func getInstaCats(from apiEndpoint: String) -> [InstaCat]? {
  if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
  
    // 1. URLSession/Configuration
    let session = URLSession(configuration: URLSessionConfiguration.default)
  
    // 2. dataTaskWithURL
    session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
    
      // 3. check for errors right away
      if error != nil {
        print("Error encountered!: \(error!)")
      }
    
      // 4. printing out the data
      if let validData: Data = data {
        print(validData)
        
          // 5. reuse our code to make some cats from Data
          let allTheCats: [InstaCat]? = InstaCatParser().parseInstaCats(from: validData)
          print("All the cats!! \(String(describing: allTheCats))")
      }
    }
    
  // 4a. ALSO THIS!
  }.resume 
}
```

Go ahead and call `getInstaCats(from:)` from `viewDidLoad` and make sure it prints out some data!

```swift 
    let instaCatEndpoint: String = "https://api.myjson.com/bins/254uw"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if let instaCatsAll: [InstaCat] = InstaCatParser().parseCats(from: instaCatJSONFileName) {
        //     self.instaCats = instaCatsAll
        // }
        
        _ = self.getInstaCats(from: instaCatEndpoint)
    }
```

> Image of output

Ok, let's now have our code return the [InstaCats] we've created just as we did in the (now) commented out code: `let instaCatsAll: [InstaCat] = InstaCatParser().parseCats(from: instaCatJSONFileName)`. Update `getInstaCats(from:)` to return `allTheCats`...

![Non-void return error](http://imgur.com/9z1Zls4l.png)

> error: `Unexpected non-void return value in void function`

#### Almost. 

We can't `return` from this block because `dataTask(with:completionHandler:)` has a function type of `(URL, (Data?, Response, Error)->()) -> ()`, so it isn't expected to return anything. 

We're going to need to make some changes to the function to have it function correctly. The simplest is to remove the `return` value and just do our UI updating work in the tableview controller directly.

```swift
  func getInstaCats(from apiEndpoint: String) { // <<< returns Void
    if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {
            
       // 1. URLSession/Configuration
      let session = URLSession(configuration: URLSessionConfiguration.default)
  
      // 2. dataTaskWithURL
      session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
    
      // 3. check for errors right away
      if error != nil {
        print("Error encountered!: \(error!)")
      }
    
      // 4. printing out the data
      if let validData: Data = data {
        print(validData)
        
        // 5. reuse our code to make some cats from Data
        // let allTheCats: [InstaCat]? = InstaCatParser().parseInstaCats(from: validData)
        print("All the cats!! \(String(describing: allTheCats))")

        // 6. if we're able to get non-nil [InstaCat], set our variable and reload the data
        if let allTheCats: [InstaCat] = InstaCatParser().parseInstaCats(from: validData) {
          self.instaCats = allTheCats
          self.tableView.reloadData()
        }
      }
      }.resume() // Other: Easily forgotten, but we need to call resume to actually launch the task
    }
  }
```

And lastly, add this to `viewDidLoad`:

```swift
  self.getInstaCats(from: instaCatEndpoint)
```

Rerun the project... Awesome! The data printed out to console.. but nothing showed up in our table view? You just met one of the biggest issues you'll encounter with network calls: updating your UI when your data is ready. Here's the most common way to update your UI following a network request:

```swift
    // update the UI by wrapping the UI-updating code inside of a DispatchQueue closure
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
```

**If you aren't familiar with `DispatchQueue` yet, just know that you need to wrap up your UI-updating code in `DispatchQueue.main.async`**

All should be well now: your request is made, data is retrieved and your tableview's UI reloads. But you might be left with some questions:

1. Why didn't we follow the MVC design pattern and put this calling code in `InstaCatParser`?
2. If we do move this into `InstaCatParser`, how do we get the `[InstaCat]` array to the table view controller if we can't return a value from `getInstaCats(from:)`
3. Why do we need to update the UI in such a special manner? 

---
### 4. Out of Order Operations (Concurrency)

Concurrency in computer science refers to _order independent execution and handling_. More importantly, it also says that although the actions you take are out of order, you always get the same expected results at the end.

For example, if you need to cook a pasta dish you could follow these broard instructions: 

1. Add water to a pot, turn on the heat. 
2. **Wait**
3. When it starts boiling, add the pasta
4. **Wait**
5. Strain the pasta when it is done cooking

But doing things one after another like this, referred to as _serial_ execution, would take a very long time, despite the guarantee that everything necessary will be done by a certain time. Not only would it take a long time, there would be stretches of time where you were doing _nothing_... just standing there, staring at a pot of water. A much more efficient way of doing is through doing _concurrent_ operations:

1. Add water to pot, turn on heat
2. **While** water comes to a boil, chop ingredients for sauce
3. Add pasta to boiling water
4. **While** the the pasta cooks, add sauce ingredients to a pan 

And if you have multiple burners on your stove, then it makes even more sense to do things in a concurrent manner.
 
Well, computers kind of work the same way. It used to be that computers only had one "burner" (called a "single core" processor) available but now they have many more at their disposal ("multi-core" processors). The purpose of this is to do as many things as possible at the same time and allow the computer to bounce between tasks as needed.

---
### 5. Network Requests are Asynchronous 

Networks can be unreliable, especially on a mobile device. And even when the network connection is good there's still a non-trivial amount of time needed for content, especially images and video, to load. Though, while that loading takes place your phone is still working, doing hundreds of other things. Though when the image or video finally does load, it appears on screen and you continue your browsing. Thanks to (in part) concurrency, your phone continues to add things to its burners while one of them waits for the "water" to boil. 

More specifically, when we talk about concurrency in networking requests, it’s usually in the realm of **asynchronous** requests. An asynchronous request is similar to concurrency in that you start it, go do something else for a little bit, and then you get alerted when it is finished. In a kitchen, you may ask your sous chef to go prep some onions for your pasta sauce while you do something else. Then once they finish chopping, you get the chopped onions back. You don’t know exactly how long this is going to take the chef; you just know you need the onions and you can’t stop everything else you’re doing while you wait for them.
 
Concurrency is a complicated topic, but Objective C and Swift make great strides towards you not having to worry about it too much. But, making network requests are always going to be done asynchronously because you can't stop other things your app is doing in order to wait for an unknown amount of time for a request to finish. You don't cook in serial, a restaurant doesn't cook a single dish at a time, and your app will always be juggling multiple tasks. 

#### The Network Cycle

At a very basic level, a network request follows the following steps:

1. `Request` is made
2. `Response` is received after some time
3. Application responds to response (either `success` or `failure`)
4. Execution continues (another request could start, or an error alert shown if there was a problem)

#### Callbacks

As first covered in the "Closures In-depth" lesson, A common pattern to "listen" for **network** responses is through the use of closures, referred to as **callbacks**. 

Closures in swift are first-class citizens which, among other things, Ymeans you can pass a closure as a parameter to another function. The twist here is that your closure is intended to be executed once your network request receives its response. So, it "waits" for the response to be retrieved while your app continues executing other code. The "lifetime" of the closure you pass into a function in this manner can "outlive" the "lifetime" of the function it's being passed to. In some ways, this **closure** enters a time machine where time stands still until the network request finishes. In the meanwhile, the rest of the function goes through each line of its code and finishes execution, unaware of the closure in the time machine. When the network call does finish, the **callback** gets the results and exits the time chamber. 

Let's now look at how this affects our current project

---

### 6. Updating `getInstaCats(from:)` to use a callback

Update `getInstaCats(from:)` to:

```swift
  // You need to include that `@escaping` keyword for callbacks
  // if you forget it, don't worry, Xcode will give you an error and ask to correct it for you
  func getInstaCats(from apiEndpoint: String, callback: @escaping ([InstaCat]?) -> Void) {
    // other code
  }
```

![Escaping Closure Warning](http://i.imgur.com/4x4UE8h.png)


Now with the function updated to use a callback closure, we can finish:

```swift
func getInstaCats(from apiEndpoint: String, callback: @escaping ([InstaCat]?) -> Void) {
  if let validInstaCatEndpoint: URL = URL(string: apiEndpoint) {

    let session = URLSession(configuration: URLSessionConfiguration.default)
  
    session.dataTask(with: validInstaCatEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
    
      if error != nil {
        print("Error encountered!: \(error!)")
      }
    
      if let validData: Data = data {
        print(validData)

        let allTheCats: [InstaCat]? = InstaCatParser().parseInstaCats(from: validData)
        callback(allTheCats)
      }
    }

  }.resume 
}
```

To verify all is working, back in `viewDidLoad`, update our code to use the new function's trailing closure syntax: 

```swift
        self.getInstaCats(from: instaCatEndpoint) { (instaCats: [InstaCat]?) in
          if instaCats != nil {
            DispatchQueue.main.async {
              self.instaCats = instaCats!
              self.tableview.reloadData()
            }
          }
        }
```
![Finished - exactly like NSURL lesson](http://imgur.com/hGB5kzam.png)

#### Explanation



#### Visualization of the callback closure lifecycle
![Closure Lifecycle](http://imgur.com/1gZ1rGy.png)

---
### 5. Exercise

(Proof of concept)

Add a `print` statement on the line just after `}.resume` along with a `print` statment just before you call `callback(allTheCats)`. Check to see which one gets printed first to console. This should help illustrate how the closure "outlives" the function.

(Warm up)

As we've learned, our callback extends the lifetime of the closure until at least the network requests finishes (in error or success). It's also what allows us to call this function from other classes. For this first exercise, refactor the code for `getInstaCat(from:callback:)` and move it into `InstaCatFactory` as a `class func`

(For the dog lovers)
Just because I like cats (like, I *really* like them), doesn't meaan you should always have to make a cat-related app. So, to give the `InstaDog`s some love, we're going to give them their own section in our table. Here's what you need to be sure you do:

1. Look at the content in https://api.myjson.com/bins/58n98
2. Create a new model `struct InstaDog`
  - Refer to your tests for the properties and functions `InstaDog` should have
3. Create a new class `class InstaDogFactory` modeled after `InstaCatFactory`
  - Meaning, this class should use a singleton, `manager`
  - This class will have two functions:
    1. `class func makeInstaDogs(apiEndpoint: String, callback: @escaping ([InstaDog]?) -> Void)`
    2. `internal func getInstaDogs(from jsonData: Data) -> [InstaDog]?`
  - Make sure that you are able to get these classes to work properly (they should hit the endpoint, retrieve the data, and parse it out into 3 `InstaDog`)
4. In the `InstaCatTableViewController` in storyboard, add a new prototype cell (be sure to give it an identifier). This prototype cell should be of type `subtitle`
5. In `InstaCatTableViewController`, add new variables to keep track of:
  1. Your new API endpoint
  2. Your new `[InstaDog]`
  3. Your cell identifier from storyboard
6. Update `numberOfRows` and `numberOfSections` so that `InstaCats` and `InstaDogs` will be separated by section
7. Add the delegate function `titleForHeaderInSection` and give each section an appropriate name 
8. Update `cellForRow` to check for the `indexPath.section` and to use the correct prototype cell for each section.
  - Take note that the `InstaDog` cells have an image and a specific format for their `detailLabel`

Your final version should look like this: 

![Final InstaDogs](http://imgur.com/MWPig7Cl.png)

*Further Work (optional, but challenging)*

If you finish the above and want to continue with this, try the following:

1. In a real world scenario, it is possible that the `json` your app is going to receive ends up being malformed (perhaps the server team makes a change your app isn't ready for). Rewrite the implementation of `struct InstaDog` to make it `throw` in the event that it cannot parse out the `json`. 
  - To test this, create your own mock `json` on myjson.com and change the endpoint for your `InstaDogFactory` to this new `json`.
2. Sort the `InstaDog` section by either `numberOfPosts`, `followers` or `following`. You must accomplish the following:
  - Create an `enum` called `InstaDogSort` with three cases: `posts, followers, following`
  - Add a `static func` to `InstaDog` that accepts parameters of `[InstaDog]` and `InstaDogSort`, and has a return of value type `[InstaDog]`

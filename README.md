# New Relic Code Challenge

## Summary
We have provided you with a skeleton app that displays a scrollable list of cat breeds. Modify and improve the skeleton app to get closer to production-ready. The app should efficiently show a very long list, and selecting an entry in the list should display more information. The user should be able to navigate back and forth between views. The app should capture performance information and display to another view.

## Primary Considerations
* Consider user experience and loading time of that experience.
* The design should be resilient with regard to network connectivity loss.
* Let the user know you are fetching/waiting for data.
* The App and its responsiveness should be optimized for maximum performance and resource usage.

We are not concerned with the visual aesthetics of the app, as long as the interface is clear and usable. Do not spend time polishing the visual aspects such as autolayout, fonts, color, accessibility, etc. Please update the architecture where needed, 

App should be as close to production-ready as possible.
Consider the possibility of adding future unit tests when writing the code.

The app should work correctly as defined below in [](#Requirements).

The code of the app should be descriptive and easy to read, and the build method and runtime parameters must be well-described and work.

## Requirements
Present a pageable main scrollable text list view that displays names of cats. The data should be fetched on demand in batches of *30*.
Use the Cat Facts API to download facts about cats (https://catfact.ninja)

Tapping cat names should display additional detail about the cat. For each network call, you capture the response time of that call. You track the average response time per API endpoint. Display these metrics and metadata in the Metrics view. Each API called during this run and average response time in milliseconds
* Device make/model
* OS version

User can navigate between all views.

Remove or keep as much of the skeleton code as you wish. You can start from scratch and create your own app as well. 

Use the latest version of Xcode.

# Notes
You may use common libraries in your project, particularly if their use helps improve Application simplicity and readability. Please update the README with any additional details and and setup instructions.

# Submission
We'll test your solution using the latest production version of the XCode and command line tools.

Sanitize the source files to remove your name from comments
- Include a README in the repo with comments:
- Clearly state all of the assumptions you made in completing the app
- If your project requires any components not found in a default install of the developer tool, you must provide instructions (and automation) to install those components (or include them in your archive).
- Any additional special instructions to set up and run project
- Push the code to a github.com repo and invite the user specified in the email.

# My Comments

TODO: 
+ Make network call a protocol type, which allows us to test easier
remove singleton class for easier testability
+ add protocol for networking to increase testability
+ Make view controllers not from storyboard
+ Fetch 25 at a time
+ Display cat breed info
+ Get response metrics for call
+ Device make/model
+ OS version
+ refactor code
+ On error make sure to alert the user
+ Maybe allow a pull to refresh(if I do make sure to mention it in the assumptions)
+ Data doesn't show activity indicator when loading. See what's going on(maybe slow connection down)
+ Double check that metrics data is correct.  It always seems to go down.
+ allow easy testing to code(Inject VM into VC using storyboard and outlets somehow?)
+ calling dispatch queue main twice?
+ remove my name
+ check for memory leaks
+ Read every line of code
+ some methods in allcats viewmodel can be marked as private
+ main thread checker

# Assumptions

I've included my TODO list of things I wanted to do in the app if you're curious of my some of my process.

I decided not to use any libraries.  I try to avoid them as much as necessary.  In my case it wouldn't have saved much time to add any so I kept them out for simplicity.

Only downloading 25 at a time because that is the API limit.

I don't like the way the current progress indicator works but I'll leave it in place to avoid working on UI/UX

It's hard for me to test this out properly since it's all text.  I'm not sure of when to fetch data or such because it's so easy to download.  Ideally we'd test this out to find an optimal time.  Maybe even variable upon a persons average response time.  If a response time is slow download more items at a time, so that the user will not have to wait.

I decided to keep as much as original code as possible.  This was in line with what I heard in the interview on when to keep code and when to refactor code.  I prefer to create ViewControllers programmatically because of merge conflicts, but in this case I'm the only one working on it and the storyboard is working fine.  

I didn't use git to write commits(except the last one maybe more if I forgot a few things)

I didn't create a great system to pass data to VC.  I don't like storyboards so I find the system a little clunky but it looks like they've add a new method call to make it easier.

I noticed the average network time always deceases after each subsequent call.  I'd like to see what's going on with Charles but I don't have that right now

Refresh indicator isn't working great.  I have a refresh cell and an indicator.  Ideally I'd make a refresh indicator at the bottom like you'd see in some infinite scroll apps(facebook). I decided against that because of the restriction on working on too much of the UI/UX

There are many hard coded numbers regarding the paginated data.  Ideally we'd get the information from the API calls and use that data. To shorten the amount of time I spent on the project I decided against that.

The alert displaying an error ins't the greatest experience while scrolling.  Again it's something I'd change if I had more time.

I'd like to refactor `getMoreCats(callback: @escaping (Error?) -> ())` { in AllCatsViewModel but I've spent enough time tinkering with it for now. 

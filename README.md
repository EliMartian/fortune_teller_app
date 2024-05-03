# Various States that an app can enter on IOS
The various states that an app can enter on IOS include: not running, suspended, inactive, active, and background.
For not running, this could be like when the user recently exited out of the app and now the app is no longer running
until the user launches the app again. Suspended is when the user might switch to another app or leave the app, but 
they have not exited out of the app so it remains in a suspended state until the user comes back to the app. Inactive
state could be like when the user gets an incoming phone call, the app is still in the foreground but is temporarily 
inactive due to some sort of an incoming event. Active is when the user is directly engaging with the app, and there
are no incoming events and the user is actively doing things within the app. Background state is when the app
is still doing something in the background / running code (could be like playing music after the device is locked, or 
maybe checking your location, etc) and thus is not currently being used, but is doing something in the background
that affects the user potentially next time they log in. 

# Various States that you need to consider for your app, why, and what happens
For my app, I need to consider not running, suspended, inactive, and active states. I want to consider the 
not running state, because I want it to be that when the user inevitably swipes out of my app and locks their phone, that
their user data is saved when the app enters the not running state, so that next time they launch the app the info is still
there which is core to their experience. To accomplish this, I store a lot of the user data using File Manager on IOS
so that all of their important larger file info is saved when the app is not running. I also consider the suspended state 
because if the user is typing in a stock for a portfolio say, and they need to go to another app to look something up about
the stock maybe, when they come back they expect that their portfolio info they were typing in is still there (otherwise they
would have to start over which is frustrating). Thus, I accomplish handling this by using things like Swift Form and TextField entities 
in conjunction with state management techniques like @State, @Binding and ObservableObject to help better keep track
of the user's currently entered info in the text box when they navigate tasks and the app goes into the suspended state.
The inactive state is equally important to consider, as if the user gets a phone call they should also not lose all of their data. By using 
the above methods, I also handle this state as well. Lastly, then the app becomes active, I want to display certain things to the user, 
like their chosen profile picture, load in the quotes from authors they chose, etc. This is handled in the entry point to my app @main
in Swift where I have an .onAppear() function which basically handles when the app launches, what should appear to the users. This 
info is important because it is customizable to the user making their experience with my app more personable, customizable, and stress free 
ideally since their information is preserved and saved throughout the app going into different states. 

# List of Features required for MVP + breaking down Deliverables 

## Feature 1: Security Search feature
Description: Where the user enters a ticker symbol, gets back some information about the performance of the security over different time periods. 

Deliverables 1: For this first feature, the deliverables required left to finish are the following: 
* Build in graph ranges so the user can choose between different time period (ie graph of 5 years, 10 years, etc).
* I would also like to add a scaler so the user can drag how much they want to invest and then get customized numbers based on however much they invested.
* Build in a few second delay when the user searches up a stock, where it shows them one of the quotes that they have selected (loading screen basically)

## Feature 2: User Portfolio create feature
Description: Where the user can build a portfolio with a name and share with others

Deliverables 2: For the second feature, the deliverables required left to finish are the following:
* Add more than just the current name, security list (of tickers) that defines a Portfolio. Would like to add at least one
of the following: a cost basis, or potentially a quantity for each share, date purchased, etc.
* The ability to edit a portfolio (and have it save / update some part of the Portfolio's information)
* Show a toast when the user adds, deletes, or edits a Portfolio on the main page

## Feature 3: User Portfolio upload / receive feature
Description: Where the user can upload a Portfolio that others send them

Deliverables 3: For the third feature, the deliverables required left to finish are the following: 
* Actually parse the string correctly that the user enters, and not just copy the last created portfolio (this is what is currently happening)

## Feature 4: User Shop feature and associated number of requests

Deliverables 4: For the fourth feature, the deliverables required left to finish are the following:
* Have "fake" options that the user can select from in the shop (does not have to actually purchase from the IOS app store), but when they click on one of these,
it should update their number of requests (of stock lookups) and display that back to them in the Profile page. 

# Mapping between value and feature for MVP (Justification) 

Feature 1 Mapping: Feature 1 allows the user to customize their investment both through cost basis (how much money they put into the stock)
and also the time (see how much the stock returns over different amounts of time). This feature is imperative to the value of Fortune Teller, 
as it's all about customer experience and customization to their personal situation. They should be able to enter different scenarios that might 
reflect their financial experience, and see how the investment would do given a certain amount of time or money. This freedom and customizability
offered by Feature 1 is core to the overall experience I am hoping to cultivate. 

Feature 2 Mapping: Feature 2 allows the user to create and put together a portfolio of stocks to keep track of. It can be difficult to mentally keep 
track of all the stocks you might want to put together, and so since Fortune Teller is intended to be a collaborative app, the goal is ultimately for 
people to be able to share these hypothetical portfolios between each other, so they could see how they perform over time. Thus, in order to share 
between users and promote collaboration and shared knowledge of security (core value of Fortune Teller), we need to allow the users to first build a portfolio 
that is customizable. 

Feature 3 Mapping: Feature 3 allows the user to upload a portfolio that they might receive from a friend or family, and then add that to their own list 
of portfolios. This is important because again due to the value of collaboration and sharing investment advice and knowledge that is one of the core principles of 
Fortune Teller, the user also needs a convenient and easy way to upload their portfolio that they receive from others, and Feature 3 delivers that for them. 

Feature 4 Mapping: Feature 4 allows the user to be able to choose a amount of stock lookups per minute that works for them, which is part of Fortune Teller's
core principle of allowing customer customizability, and allowing users to only pay for what they need. That being said, Fortune Teller also anticipates
the need to be scalable and have a way to limit and rate customers, which is why having the customer limit and ability to pay for additional
lookups is essential to the value of customizability, and providing additional value in terms of usability for the customers using the app. 

# Explanation of Storage Approaches on IOS Platform

There are a bunch of different storage approaches on IOS, including: UserDefaults, FileManager, Core Data, and Cloud Storage just to name a few.
UserDefaults are great for storing small pieces of info about user settings or preferences, but they have a very small storage space as I found
out through implementation. Ideally, UserDefaults could be something pretty simple, such as DarkMode or LightMode being toggled on. I was intially
trying to store several investor quotes in there. FileManager is great for managing things like user generated content such as images, documents, or 
other data that could live in files. I found FileManager to be ideal for storing the user's preferred profile picture that they could updload
to their profile page. FileManager is greate because it works for a lot of different sized files within the file system. Core Data is another 
important way to store information on IOS, which I used for storing my investor quotes ultimately. Core Data is awesome because it focuses on 
storing structured data and relationships (similar to a database) and can handle complex models and provides some handy data management features. 
Another possible option is Cloud Storage, which could be nice to use if you want to offload storage to remote servers, which is important
if you anticipate needing to scale your amount of user data and for better synchronization. Cloud Storage also reduces the local storage on the 
user's phone naturally, which is also suitable for particularly vast volumes of data or users. 

# Pros and Cons of each Approach for Fortune Teller

UserDefaults: Pros include the lightweight ability to store information. However, at this time I don't have any user data that is simple
and boolean in nature enough to be stored here (such as DarkMode for ex). Cons for my project would be that UserDefaults simply cannot handle
the size of the data and types of data that I wanted to store for users. 

FileManager: Pros for this option were great, I used FileManager to store the user's profile picture choice, which makes sense because it inherently
deals with storing and loading user generated content that falls into a file-based format. I cannot think of a con for this option other than that
for my project the data would have to naturally fall into an acceptable file format first, which luckily I did have a type. But it does not 
make sense to exclusively use FileManager for all data, especially if your data has relationships. 

Core Data: Pros for Core Data was that it supports relationships and works on structured data (like famous investor quotes), which was nice
because it exhibits database like properties. Cons for my project was that it was a little hard to set up, so I had to look up a few resources
to get Core Data working. Also the overhead required for it might not be beneficial in all circumstances, but I felt like it made sense to learn
about how to set this up in my case. 

Cloud Storage: Pros for Cloud Storage could be again that it is highly scalable and vastly reduces the amount of data that needs to be stored locally. 
For my project though, the reason I didn't implement this was because it costs money to set up usually and also requires the need to utilize its scaling 
services, on top of the development overhead. Thus, this was one con that made me not want to incorporate it yet into my project. 

# Brief Description of how design is relevant to Target Audience
The UI/UX included in the design submission screenshots appeal to the target audience of new investors by 
providing a seamless and intuitive experience to be able to easily search and get information in a way that 
is familiar to them and similar to something they understand (like the Apple Stocks app but with extra features). 
Moreover, the design appeals to the audience that wants a social experience and to share and build cool portfolios with 
their friends and family as it offers a convenient and familiar experience to puttting together and customizing a portfolio, 
and then offers the ability to share / load the new content in the user experince seemlessly by including common functionality
like AirDrop, Messages app, Email, etc. The UI/UX also enables more active investors who require greater resources by providing 
transparency in the in-app purchase tiers and exactly what their money is going towards and how much value they are receiving 
as a result so they can guage their purchase requirements accordingly. 

# Project Name / Version
Fortune Teller, Version 1

# Project Members
Elias Martin

# Summary of Project
Fortune Teller lowers the barrier for new investors to enter the world of investing through providing tools that provide clear 
and easy insight into the financial movements of any security. Additionally, the unique research tools and customizability to 
create, rate, and send portfolios to friends and family, coupled with other customizable investment tools bring value to customers. 
Fortune Teller creates an community of investing research by demistifying and lowering the barrier to entry.

# Project Analysis
# Value Proposition

Investing is traditionally a world obscured by financial advisors and so called "money-gurus" (1). These individuals 
aim to keep the barrier to learning and understanding investment basics high, so that it can be challenging for new
investors to get started with investing. In fact, on average it can take the average person between one and five years
to get started with investing (2), which indicates that it takes a while to get acclimated to the intricacies of investing. 
Fortune Teller drastically cuts down on the time it takes to learn to invest by allowing customers to easily look up any 
security and understand how its past performance might influence its future performance, increasing their understanding 
by providing them exactly the data they need. Investing is often considered a taboo topic to talk about, as many people 
prefer to work in private with a financial advisor to understand their needs. However, like anything though, having more 
discussions about the topic and allowing conversations to flow freely about our investment decisions backed up by actual 
performance metrics only raises the bar for investments and increases overall community knowledge. Fortune Teller enables 
all of this and more by building features that give more customizability and flexibility to the customer than ever. 
(1) https://www.bankrate.com/investing/financial-advisors/when-to-get-a-financial-advisor/
(2) https://www.nobledesktop.com/learn/investing/how-long-does-it-take-to-learn-investing#:~:text=Average%20Time%20it%20Takes%20to,make%20trades%20to%20become%20successful. 

# Primary Purpose

The primary purpose of Fortune Teller is to increase public awareness and knowledge surrounding investing and 
learning how to use the stock market to build wealth in a safe and predictable pattern over time. It is the culimination
of my personal knowledge and quest to learn more over the past four years, and reflects some of the custom tools I built for 
myself because they genuinely didn't exist anywhere else on the market. 

# Target Audience

My target audience would be people of all backgrounds who want to learn more about investing. To reach such a target audience,
I plan to do some advertising on subreddits that focus on investing and building knowledge about the market. New investors would
also be a target audience of mine, and I plan to explore similar online avenues to connect with these users and advertise to them as well. 

# Success Criteria

I would prefer to measure the success of my app by the number of daily active users. My hope is that 
people could visit this app once a day fleetingly to look up their favorite stock, or maybe send a new 
portfoio to a friend to compare performance. If the number of daily users exceeds 250 people, I think
I would consider this to be a success for the app. 

# Competitor Analysis

I don't know of any competitors that focus solely on building tools for their customers outside of brokerages like
Fidelity for example. While their tools and features are great, the point of Fortune Teller is to devlop 
features and tools that don't exist on any other brokerage platform, so I am genuinely not aware of any competitors 
at this time. The closest thing could be like what Robinhood did for the brokerage community by lowering the entry to 
investing, but Robinhood differs in that it focuses on letting users open real accounts with real money. Fortune Teller 
focuses solely on building theoretical stocks / portfolios for research purposes. Sites like Investopedia also 
inspired this work on Fortune Teller, but while they offer high quality information they don't promote a social aspect
to their information or offer significant research tools from what I've seen. Thus, Fortune Teller exists in a niche market. 

# Monetization Model

I propose a "Freemium" subscription model, in which a new free user is allowed a certain amount of security "lookups"
per minute, and these users are throttled if they exceed the amount. Paying users can choose different packages to unlock 
more lookups, similar to how an API operates. Of course, free users will always be throttled last so that paying users 
are prioritized, thus incentivizing them to switch to be paying customers and driving revenue. 

# Initial Design

An MVP for Fortune Teller is important to define, since its scope is quite vast. 
A MVP for Fortune Teller would consist of the following elements: 
The ability for a user to look up a stock and see its performance + some sort of 
information about its rating over different time and investment intervals, the ability to put together a portfolio 
of stocks and send it to other users via something like the Messages app on IOS (in some sort of format), and then have the receiving
user be able to take that format, and somehow upload it / get it into their own Fortune Teller app to be able to see
that rating for the portfolio. This is expected to be difficult, so if the Messages app does not work, other formats like email
or something else would be acceptable for an MVP. Also as an MVP, I would like for the user to be able to choose one of the payment tiers
in the in-app purchase part of Fortune Teller to be able to choose how many requests and security lookups they can get each minute. This 
does not have to actually take their money, but the feature should work to be able to differentiate their experience between users in some way
depending on payment level. 

Outside of the MVP, I would also like to have a feature that sends an alert to a receiving user who got a new portfolio / stock. 
I would also like to have a feature where the user can choose different metrics to graph their performance or other metrics 
against common indices like the DSJ, S&P, etc. I would also like for the user to be able to save a portfolio and leave the app, 
come back to it and have the portfolio still be there (instead of just being visible only when uploading from a friend). 
These however would be reach goals since I am taking 15 credits and am an ML Research Assistant this quarter, but I will do my best. 

# UI/UX Design

The customer should be able to look up a security, see information about it displayed to them, and 
be able to change the time range invested or the amount invested. The customer should also be able 
to add multiple securities to a portfolio, then get information on that portfolio's value and be 
able to somehow share that with other people. The people receiving it should be able to upload it 
within their app, see the same information and rating / value info that the sender did, and can 
choose to add the portfolio if they wish. The user should also be able to select from an array of tiers
as to what subscription level they want to pay for, and the app should respond to them differently 
because of this. 

# Technical Architecture

The necessary components to ensure an MVP include an API, and also likely some sort of a database to store their 
portfolios that they generate or receive from friends, although this would not be part of the MVP. The largest component of this 
technical architecture that I can currently see is the necessity of the Alpha Vantage API key that I will use to make requests from. 
However, would also likely want to keep this key a secret, despite having users be able to make requests all using the same shared key. 
So some sort of rudimentary cryptography might be useful for this shared secret. 

# Challenges and Open Questions

Some technical challenges will likely be figuring out how to secretly communicate the shared API key, figuring out how to work with 
Apple in-app purchases, throttling requests, working with using the Messages app and other apps to share information across devices, 
figuring out how to condense some sort of a security or portfolio into a shareable format, figuring out how that information is going 
to be stored, etc. For the MVP considerations, like how to upload and receive basic file formats and take advantage of in-ecosystem things 
like using the Messages app or sending notifications via the app on IOS, I plan to look into finding some good documentation on Apple's Swift 
tutorials and also maybe look on YouTube. To answer the other questions (of which the majority are not part of the MVP), I will likely be looking into implementing 
a basic cryptography approach (using someone else's instead of rolling my own crypto), looking into best practices for throttling requests based 
on how we treat different customers (paying or non-paying), as well as figuring out what communicating and storing data like security ratings and 
portfolios will look like by exploring popular cloud service providers and other free alternatives. I do not have any additional questions at this time, 
and I hope that by keeping the MVP manageable for this project it does not become too overwhelming this quarter, but rather gives me a solid 
foundation to keep building off on in the coming months. Thank you for reading my proposal. 

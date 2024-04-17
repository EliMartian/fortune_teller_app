# Brief Description of how design is relevant to Target Audience
The UI/UX included in the design submission screenshots appeal to the target audience of new investors by 
providing a seamless and intuitive experience to be able to easily search and get information in a way that 
is familiar to them and similar to something they understand (like the Apple Stocks app but with extra features). 
Moreover, the design appeals to the audience that wants to share and build cool portfolios with their friends 
as it offers a convenient and familiar experience to puttting together and customizing a portfolio, and then 
offers the ability to share / load the new content in the user experince seemlessly. The UI/UX also enables
more active investors who require greater resources by providing transparency in the in-app purchase tiers and 
exactly what their money is going towards and how much value they are receiving as a result so they can guage 
their purchase requirements accordingly. 

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

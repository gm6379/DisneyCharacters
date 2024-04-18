# Disney Characters coding task

## Brief from task:
A designer in your team has been working on an app called “Characters” and has sent you a design mockup (attached). The app uses the Disney characters API (https://disneyapi.dev) to fetch all the characters and displays them to the user.
The app needs to have some support for offline usage even if that means the user will have a slightly degraded experience (e.g. some images won’t be shown).
Ideally, the characters should be shown in the order of popularity. Popularity is measured by how many films and park attractions the character is featured in.

You should spend no more than 3-4 hours on the project - we know this isn't anywhere near enough time to complete the spec, so no pressure to build all the features or fix all the bugs! We're interested to see how far you get in that time and the decisions you make along the way. Please include a short note with your response, explaining:

## Questions:
### 1.	What were your priorities, and why?
-	Building an effective way of requesting all data on app start – the API returned data in a paged manner, it was therefore required to build a mechanism to consume this paged data and insert into the persistent store
-	Ensuring data could be stored on disk – set up the core data model, building a generic way to store data locally
-	Unit testing – testing the repository to ensure the view could consume the paged data
-	Timeout of cached, to ensure data is accurate
### 2.	If you had another two days, what would you have tackled next?
-	Attach the Paging concept to the core data model, allocating a score within core data to only fetch data from the store that is needed to display the current set of pages, currently we load the entire data into memory, to then sort based on the scores. When we navigate to the final page of our current view pager, it then reads all data again. We can build a system which only fetches the first set of paged data based on highest scores.
-	Unit testing the ViewModel
-	Improve code readability
-	Code comments
### 3.	What would you change about the visual design of the app?
-	Implement the swiping navigation
-	Improve layout of content, currently is a bit jumpy
-	Improve loading of images to ensure they are timed with page navigation
### 4. What other features would you add to the app?
-	Favoriting of characters
-	Searching through characters

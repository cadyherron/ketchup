# ketchup


#### WHAT IS THIS?

Ketchup is a service that takes all your commits to forked projects and mirrors them to your public commit history.


#### WHY SHOULD I USE THIS?

Let's say you're enrolled in a program where you fork a repository, build an app, and submit a pull request. That pull request will never be accepted. But you still want all your hard work to show up in those encouraging little green boxes on your Github profile. Enter... ketchup.


#### HOW DO I RUN THIS THING?

Step 1: Generate a personal access token through Github
* Go to your settings page (the gear icon in your navbar).
* On the left side, click the "Personal access tokens" tab.
* Generate a new access token with permissions for "public repo", "repo status", and "notifications".
* Copy down that token.

Step 2: Clone this repo

Step 3: Run the following from the command line:

`irb`
`load 'ketchup.rb'`
`k = Ketchup.new('github_username', 'github_api_key')`
`k.run`
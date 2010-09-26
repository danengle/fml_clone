Feature: user creates post
	As a user
	I want to create a post
	So that I can share it
	
	Scenario: create post when not logged in
		Given I am not logged in
		When I create a new post
		Then I should see "Thanks for submitting."
		
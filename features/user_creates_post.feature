Feature: user creates post
	As a user
	I want to create a post
	So that I can share it
	
	Scenario: create post when not logged in
		Given I am not logged in
		When I go to the new post page
		And I create a post
		Then a new post will be created
		And the post will be pending review
		And I should be on the posts page
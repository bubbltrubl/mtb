Feature: Landing Page
	So that I can subscribe to MegaTomBike 2011
	As a cycling lover
	I want to able to subscribe to MTB 2011

@landing
Scenario: Click on the subscribe button
	Given I am on the landing page
	When I click on the subscribe button
	Then I should go to the subscribe page

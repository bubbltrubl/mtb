Given /^I am on the landing page$/ do
  visit root_path
end

When /^I click on the subscribe button$/ do
  click_link "Inschrijven" 
end

Then /^I should go to the subscribe page$/ do
  response.should contain("Maak je ploeg")
end

Feature: Search offers

  Scenario: Displaying form errors
    When I don't fill the search form
    Then I should see the errors

  Scenario: Searching offers
    When I fill the search form with the correct params
    Then I should see the offers

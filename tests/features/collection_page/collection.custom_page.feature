@api
Feature: "Add custom page" visibility options.
  In order to manage custom pages
  As a collection member
  I need to be able to add "Custom Page" content through UI.
  Background:
    Given users:
    | name            | mail                  | roles         | pass |
    | Rufus Drumknott | member@example.com    |               | test |
    And the following collections:
    | uri                             | name           | description               | logo     |  owner |
    | http://joinup.eu/collection/foo | Foo Collection | This is a foo collection. | logo.png |        |
    | http://joinup.eu/collection/bar | Bar Collection | This is a bar connection. | logo.png |        |
    And the following user memberships:
    | group_type | group_id                         | member          |
    | rdf_entity | http://joinup.eu/collection/foo  | Rufus Drumknott |

  Scenario: Check visibility of the "Add custom page" button.
    When I am logged in as "Rufus Drumknott"
    And I go to the homepage of the "Foo Collection" collection
    Then I should see the link "Add custom page"
    When I click "Leave this collection"
    And I press the "Confirm" button
    Then I should not see the link "Add custom page"
    When I go to the homepage of the "Bar Collection" collection
    Then I should not see the link "Add custom page"
    But I should see the button "Join this collection"
    When I press the "Join this collection" button
    Then I should see the link "Add custom page"

  Scenario: Add custom page as a collection member.
    When I am logged in as "Rufus Drumknott"
    And I go to the homepage of the "Foo Collection" collection
    Then I should see the link "Add custom page"
    When I click "Add custom page"
    Then I should see the text "Add custom page"
    And the following fields should be present "Title, Body"
    And the following fields should not be present "Groups audience, Other groups"
    When I fill in the following:
      | Title       | Custom page title                                                       |
      | Body        | This is some dummy description not meant to explain or define anything. |
    And I press "Save"
    Then I should have a "Custom page" content page titled "Custom page title"
    And the "Custom page title" of type "node" should be a member of the "rdf_entity" with ID "http://joinup.eu/collection/foo"

  Scenario: Add custom page as a moderator.
    When I am logged in as a user with the "moderator" role
    And I visit "node/add/custom_page"
    And the following fields should be present "Title, Body"
    #And the following fields should be present "Groups audience, Other groups"
    When I fill in the following:
      | Title         | Custom page title                                                       |
      | Body          | This is some dummy description not meant to explain or define anything. |
      | Other groups  | Foo Collection (http://joinup.eu/collection/foo)                        |
    And I press "Save"
    Then I should have a "Custom page" content page titled "Custom page title"
    And the "Custom page title" of type "node" should be a member of the "rdf_entity" with ID "http://joinup.eu/collection/foo"

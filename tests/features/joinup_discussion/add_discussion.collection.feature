@api
Feature: "Add discussion" visibility options.
  In order to manage discussions
  As a collection member
  I need to be able to add "Discussion" content through UI.

  Scenario: "Add discussion" button should not be shown to normal members, authenticated users and anonymous users.
    Given the following collections:
      | title              | logo     | banner     | state     |
      | The Fallen History | logo.png | banner.jpg | validated |
      | White Sons         | logo.png | banner.jpg | validated |

    When I am logged in as an "authenticated user"
    And I go to the homepage of the "The Fallen History" collection
    Then I should not see the link "Add discussion"

    When I am an anonymous user
    And I go to the homepage of the "The Fallen History" collection
    Then I should not see the link "Add discussion"

    When I am logged in as a member of the "The Fallen History" collection
    And I go to the homepage of the "The Fallen History" collection
    Then I should see the link "Add discussion"

    When I am logged in as a "facilitator" of the "The Fallen History" collection
    And I go to the homepage of the "The Fallen History" collection
    Then I should see the link "Add discussion"
    # I should not be able to add a discussion to a different collection
    When I go to the homepage of the "White Sons" collection
    Then I should not see the link "Add discussion"

    When I am logged in as a "moderator"
    And I go to the homepage of the "The Fallen History" collection
    Then I should see the link "Add discussion"

  Scenario: Add discussion as a facilitator.
    Given collections:
      | title                  | logo     | banner     | state     |
      | The World of the Waves | logo.png | banner.jpg | validated |
    And I am logged in as a facilitator of the "The World of the Waves" collection

    When I go to the homepage of the "The World of the Waves" collection
    And I click "Add discussion" in the plus button menu
    Then I should see the heading "Add discussion"
    And the following fields should be present "Title, Content, Policy domain, Add a new file"
    # The entity is new, so the current workflow state should not be shown.
    And the following fields should not be present "Current workflow state, Motivation"

    # The section about managing revisions should not be visible.
    And I should not see the text "Revision information"
    And the following fields should not be present "Create new revision, Revision log message, Shared in"

    # Check required fields.
    And I attach the file "test.zip" to "Add a new file"
    And I press "Upload"
    And I press "Publish"
    Then I should see the following lines of text:
      | Title field is required.            |
      | File description field is required. |
      | Content field is required.          |

    When I fill in the following:
      | Title            | An amazing discussion                      |
      | Content          | This is going to be an amazing discussion. |
      | File description | The content of this file is mind blowing.  |
    And I press "Publish"
    Then I should see the heading "An amazing discussion"
    And I should see the success message "Discussion An amazing discussion has been created."
    And the "The World of the Waves" collection has a discussion titled "An amazing discussion"
    # Check that the link to the discussion is visible on the collection page.
    When I go to the homepage of the "The World of the Waves" collection
    Then I should see the link "An amazing discussion"

    # Regression test: the workflow state should not be shown to the user.
    When I click "An amazing discussion"
    Then I should see the heading "An amazing discussion"
    But I should not see the text "State" in the "Content" region
    And I should not see the text "Validated" in the "Content" region

@api
Feature: Password management
  As a registered user of the website
  I want to be able to manage and restore my password
  So that I can access my account

  Background:
    Given users:
      | Username       | E-mail                     | Password | First name | Family name |
      | Charlie Change | charlie.change@example.com | changeme | Charlie    | Change      |

  Scenario Outline: A registered user cannot set passwords that do not comply with the policy.
    When I am logged in as "Charlie Change"
    And I am on the homepage
    And I click "My account"
    And I click "Edit"
    And I fill in "Current password" with "changeme"
    And I fill in "Password" with "<password>"
    And I fill in "Confirm password" with "<password>"
    And I press the "Save" button
    Then I should see the error message "The password does not satisfy the password policies"
    Examples:
      | password   |
      # Less than 8 characters.
      | tEst1      |
      # Contains only lowercase and uppercase.
      | tEsttest   |
      # Contains only lowercase and uppercase.
      | t3sttest   |
      # Contains only lowercase and special characters.
      | testtest!  |
      # Contains only numeric and special characters.
      | 123456789! |
      # Contains only uppercase and special characters.
      | TESTTEST!  |

  Scenario: A logged-in user can navigate to his profile and change his password.
    When I am logged in as "Charlie Change"
    And I am on the homepage
    And I click "My account"
    And I click "Edit"
    And I fill in "Current password" with "changeme"
    And I fill in "Password" with "Cr4bbyP4tties"
    And I fill in "Confirm password" with "Cr4bbyP4tties"
    And I press the "Save" button
    Then I should see the success message "The changes have been saved."

  @email
  Scenario: A user can request a one-time-login link.
    When I am an anonymous user
    And I am on the homepage
    And I click "Log in"
    And I click "Reset your password"
    And I fill in "Username or email address" with "Charlie Change"
    And I press the "Submit" button
    Then I should see the success message "Further instructions have been sent to your email address."
    And the following email should have been sent:
      | recipient | Charlie Change                                                           |
      | subject   | Replacement login information for Charlie Change at Joinup               |
      | body      | A request to reset the password for your account has been made at Joinup |

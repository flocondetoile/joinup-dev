@api
Feature: Creation of news through the UI.
  In order to manage news
  As a user
  I need to be able to create news through the UI.

  Scenario: Share the news in other collections/solutions.
    Given the following collections:
      | title            | description                                 | logo     | banner     | state     |
      | Metal fans       | Share the love for nickel, tungsten & co.   | logo.png | banner.jpg | validated |
      | Hardcore diggers | We dig up stuff hidden beneath the earth.   | logo.png | banner.jpg | validated |
      | Cool blacksmiths | Keeping it cool while working on hot stuff. | logo.png | banner.jpg | validated |
    And solutions:
      | title                     | description                               | logo     | banner     | state     |
      | Density catalogue project | Catalog density on metals with ease.      | logo.png | banner.jpg | validated |
      | Dig do's and don'ts       | How to dig up stuff with style.           | logo.png | banner.jpg | validated |
      | Anvil test routines       | How to determine reliability of the tool. | logo.png | banner.jpg | validated |

    When I am logged in as a "facilitator" of the "Metal fans" collection
    And I go to the homepage of the "Metal fans" collection
    And I click "Add news"
    And I fill in the following:
      | Kicker   | Ytterbium metal of the year                                                                   |
      | Headline | Strong request for this rare metal that is on the mouth of everybody                          |
      | Content  | Thanks to its lower density compared to thulium and lutetium its applications have increased. |

    # Sharing inside the same parent should not be possible.
    And I fill in "Shared in" with "Metal fans"
    And I press "Validate"
    Then I should see the error message "You cannot reference the parent Metal fans in field Shared in."

    # Sharing into a solution should not be possible.
    When I fill in "Shared in" with "Density catalogue project"
    And I press "Validate"
    Then I should see the error message 'There are no entities matching "Density catalogue project".'

    # Share the content in another collection.
    When I fill in "Shared in" with "Hardcore diggers"
    And I press "Validate"
    Then I should see the success message "News Ytterbium metal of the year has been created."
    # Verify that the referenced collection is rendered as tile.
    #And I should see the "Hardcore diggers" tile

    # Edit again and try to share into the same collection.
    When I click "Edit" in the "Entity actions" region
    And I fill in "Shared in" with values "Hardcore diggers, Hardcore diggers"
    And I press "Update"
    Then I should see the error message "The value Hardcore diggers is already selected for field Shared in."

    # Add another collection in the field.
    When I fill in "Shared in" with values "Hardcore diggers, Cool blacksmiths"
    And I press "Update"
    Then I should see the success message "News Ytterbium metal of the year has been updated."
    # Verify that the tiles are shown.
    #Then I should see the "Hardcore diggers" tile
    #And I should see the "Cool blacksmiths" tile

    # @todo Add test coverage for solutions when ISAICP-2544 work is done.

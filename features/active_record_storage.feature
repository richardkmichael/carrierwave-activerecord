Feature: Uploader with ActiveRecord storage
  In order to reduce infrastructure complexity
  As a developer using CarrierWave
  I want uploaded files to be stored in the database

  Background:
    Given an uploader using 'active_record' storage

  Scenario: Store a file
    When I upload the fixture file 'plain_text.txt'
    Then the file should be stored in the database
    And the database file should be identical to the fixture file

# Scenario: store two files in succession
#   When I store the file 'fixtures/plain_text.txt'
#   Then there should be one file in the database named 'plain_text.txt'
#   And that file should be identical to the file at 'fixtures/plain_text.txt'
#   When I store the file 'fixtures/monkey.txt'
#   Then there should be one file in the database named 'monkey.txt'
#   And that file should be identical to the file at 'fixtures/monkey.txt'

# Scenario: storing two files of the same name
#   When I store the file 'fixtures/plain_text.txt'
#   Then there should be one file in the database named 'plain_text.txt'
#   And that file should be identical to the file at 'fixtures/plain_text.txt'
#   When I store the file 'fixtures/plain_text.txt'
#   Then there should be two files in the database named 'plain_text.txt'
#   And that file should be identical to the file at 'fixtures/plain_text.txt'

# Scenario: cache a file and then store it
#   When I cache the file 'fixtures/plain_text.txt'
#   Then there should be one file called 'plain_text.txt' somewhere in a subdirectory of 'public/uploads/tmp'
#   And the file called 'plain_text.txt' in a subdirectory of 'public/uploads/tmp' should be identical to the file at 'fixtures/plain_text.txt'
#   And there should not be one file at 'public/uploads/plain_text.txt'
#   When I store the file
#   Then there should be one file in the database named 'plain_text.txt'
#   And that file should be identical to the file at 'fixtures/plain_text.txt'

# Scenario: retrieving a file from cache then storing
#   Given the file 'fixtures/plain_text.txt' is cached file at 'public/uploads/tmp/20090212-2343-8336-0348/plain_text.txt'
#   When I retrieve the cache name '20090212-2343-8336-0348/plain_text.txt' from the cache
#   And I store the file
#   Then there should be one file in the database named 'plain_text.txt'
#   And that file should be identical to the file at 'fixtures/plain_text.txt'

# This should 'disable', and watch the tmp dir while storing (because storing moves a file through the cache).
# Scenario: disabling the cache prevents writing to the local filesystem
#   When I disable the local cache
#   When I cache the file 'fixtures/plain_text.txt'
#   Then there should not be one file called 'plain_text.txt' somewhere in a subdirectory of 'public/uploads/tmp'
#   And I store the file
#   Then there should be one file in the database named 'plain_text.txt'
#   And that file should be identical to the file at 'fixtures/plain_text.txt'

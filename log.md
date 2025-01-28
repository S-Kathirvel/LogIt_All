# Project Log

This log documents the changes made to the Streak Habit Tracker app in the LogIt_All project.



## App 1: Streak Habit Tracker:
### Summary of Changes

1. **Updated Home Page**:
   - Implemented the Home page for the Streak Habit Tracker with:
     - A placeholder habit.
     - A bottom navigation bar for Home and Settings.
     - A "Done" button to mark habits.
     - Smiley emoji and streak display functionality.
1. **Created Habits Page**:
   - Developed the Habits Page with:
     - A loading effect that fills the habit icon when marked.
     - Streak count displayed with a fire emoji.
3. **Settings Page**:
   - Linked the Settings Page to the navigation bar.
4. **Updated Styling**:
   - Ensured the UI follows a dark mode theme with appropriate colors and sizes.
5. **Implemented Shared Preferences**:
   - Set up shared preferences for storing habit streaks.
   - Added functions to save and retrieve habit data.
6. **Updated Habits Page**:
   - Refactored the logic to ensure each habit's streak count is managed individually.
   - Adjusted the layout to improve the user interface.
7. **Created Habit Info Page**:
   - Designed the Habit Info Page to display the habit name and provide options to edit or delete.
8. **Settings Page**:
   - Integrated the settings page to display stored habits.

9. - **Prompt**: Remove Roboto fonts and revert to default font.
  - **Changes Made**:
    - **home_page.dart**: Improved card layout and text formatting for better visibility of emojis and titles.
    - **pubspec.yaml**: Removed `google_fonts` dependency.
    - **main.dart**: Updated to use the default Flutter font instead of Roboto.

- **Attempted to rename** app1 to **Streak Habit Tracker** in the file path, but encountered an error due to the command not being recognized.
And fixed it manually by renaming the files and the code.
----
- **Updated Memory**: Always log after every prompt automatically. Current work is only on **lib/StreakHabitTracker** and its pages.


## App 2: Watched Movies Log

### Summary of Changes

1. **Created Database**: Implemented a simple database to store movie details.
2. **Developed Pages**:
   - **Add Movies Page**: Created a page for logging movies.
   - **Show Movies Page**: Developed a page to display the list of watched movies.
   - **Settings Page**: Added functionality for managing movies and toggling themes.
3. **Removed Placeholder File**: Deleted the placeholder file as we have developed the actual pages.

4. **Added Dummy Data**: Implemented a method to add dummy movie data to the MovieDatabase for testing purposes.
   - Movies added: Inception, The Dark Knight, Interstellar.

5. **Edit Database Functionality**: Enhanced the Edit Database Page to allow users to edit all fields of a selected movie.
   - Users can now modify the movie name, year of release, genres, date watched, and rating.
   - Added delete functionality to remove movies from the database.

6. **Export Database Functionality**: Implemented the ability to export the movie database to a CSV file.
   - Users can export the list of movies to a CSV format that can be stored and shared.

7. **Fixed UI Issues**: Resolved issues with the display of movies in the Edit Database and Export Database pages.
   - Ensured that the FutureBuilder correctly fetches data from the database.

8. **General Improvements**: Made various updates to enhance the overall functionality and user experience of the app.

### Commit Message
"Added dummy data to the MovieDatabase, enhanced edit database functionality, implemented export database functionality, fixed UI issues, and made general improvements to the Watched Movies Log app. These changes improve the app's usability, functionality, and user experience."
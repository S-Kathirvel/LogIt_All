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


## App 2: Watched Movies Log (31st January 2025)

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


## Movie Log App Updates - 2025-01-29

1. **Removed Web-Related Code**: Eliminated all web-specific imports and code from the project, focusing solely on Android functionality to streamline the app.
2. **Updated Main Functionality**: Modified the `main.dart` file to remove references to `window`, enhancing compatibility with mobile platforms. The reload button now provides a message indicating that the app needs to be restarted manually.
3. **Database Improvements**: Ensured the `database.dart` file is free of web-related code, allowing for proper initialization of the SQLite database on Android.
4. **Version Control**: Discussed how Flutter determines version numbers based on the `pubspec.yaml` file, with plans to update the version number for the next build cycle.
5. **Web Directory Removal**: Deleted the entire `web` directory and its contents to maintain a clean project structure, ensuring no unnecessary files remain.
6. **APK Build Preparation**: Prepared the app for building an APK to facilitate testing on Appetize.io, ensuring all dependencies are correctly set.
7. **Commit Message**: Updated the commit message to reflect today's changes, ensuring clarity in version control history.

## Movie Log App Updates - 2025-01-30

1. **Implemented Core Functionalities**:
   - Developed features for viewing, adding, editing, and deleting movies. This includes a user-friendly interface that allows users to manage their movie collection efficiently.
   - Created an export feature for movies, enabling users to export their watched movies in multiple formats (CSV, JSON, XLSX) for easy sharing and analysis.

2. **Edit Functionality**:
   - Created an `EditMoviePage` that allows users to modify existing movie details. Users can update fields such as name, year, genre, and rating, enhancing the app's usability.

3. **Export Functionality**:
   - Set up an `ExportDatabasePage` where users can select their desired export format. This functionality ensures that users can easily back up or share their movie data.

4. **Settings Page Update**:
   - Added navigation to the export functionality from the settings menu, making it more accessible for users to find and use the export feature.

5. **Fixed Build Errors**:
   - Resolved various build errors related to missing parameters and type mismatches in the Excel export logic. This included ensuring that the correct types were used for cell values and fixing method signatures.

6. **UI Simplification**:
   - Implemented a simple UI for the export page to facilitate quick testing of export functionalities. This allows for immediate feedback on the export process without complex UI elements.

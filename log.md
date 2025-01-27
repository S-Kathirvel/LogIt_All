# Project Log

This log documents the changes made to the Streak Habit Tracker app in the LogIt_All project.

## Summary of Changes

1. **Renamed the Project**: Changed the project name from `personal_apps` to `LogIt_All`.
2. **Updated Home Page**:
   - Implemented the Home page for the Streak Habit Tracker with:
     - A placeholder habit.
     - A bottom navigation bar for Home and Settings.
     - A "Done" button to mark habits.
     - Smiley emoji and streak display functionality.
3. **Created Habits Page**:
   - Developed the Habits Page with:
     - A loading effect that fills the habit icon when marked.
     - Streak count displayed with a fire emoji.
4. **Settings Page**:
   - Linked the Settings Page to the navigation bar.
5. **Updated Styling**:
   - Ensured the UI follows a dark mode theme with appropriate colors and sizes.
6. **Implemented Shared Preferences**:
   - Set up shared preferences for storing habit streaks.
   - Added functions to save and retrieve habit data.
7. **Updated Habits Page**:
   - Refactored the logic to ensure each habit's streak count is managed individually.
   - Adjusted the layout to improve the user interface.
8. **Created Habit Info Page**:
   - Designed the Habit Info Page to display the habit name and provide options to edit or delete.
9. **Settings Page**:
   - Integrated the settings page to display stored habits.

- **Prompt**: Remove Roboto fonts and revert to default font.
  - **Changes Made**:
    - **home_page.dart**: Improved card layout and text formatting for better visibility of emojis and titles.
    - **pubspec.yaml**: Removed `google_fonts` dependency.
    - **main.dart**: Updated to use the default Flutter font instead of Roboto.

- **Attempted to rename** app1 to **Streak Habit Tracker** in the file path, but encountered an error due to the command not being recognized.
And fixed it manually by renaming the files and the code.
----
- **Updated Memory**: Always log after every prompt automatically. Current work is only on **lib/StreakHabitTracker** and its pages.
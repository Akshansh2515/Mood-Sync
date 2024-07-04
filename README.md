# Flutter Notes App

This Flutter Notes App is designed to help you create, edit, and delete notes efficiently. It includes an emotion detection feature that analyzes the content of your notes and suggests songs based on the detected emotions. The notes are displayed in a grid with pastel and soft colors randomly assigned to each note for a pleasant visual experience.

## Features

- Add, edit, and delete notes.
- Emotion detection in note content.
- Song recommendations based on detected emotions.
- Randomly assigned pastel and soft colors for notes.
- Persistent storage of notes.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev) installed on your machine.
- [Dart](https://dart.dev) installed on your machine.

### Installation

1. Clone the repository:

    ```sh
    git clone https://github.com/Akshansh2515/Mood-Sync.git
    cd flutter-notes-app
    ```

2. Install dependencies:

    ```sh
    flutter pub get
    ```

3. Run the app:

    ```sh
    flutter run
    ```

## Project Structure

- `lib/`
    - `main.dart`: The entry point of the application.
    - `note.dart`: The model class for the Note.
    - `noteStorage.dart`: The class for handling persistent storage of notes.
    - `editNotePage.dart`: The page for adding and editing notes.
    - `EmotionDetector.dart`: The class for detecting emotions in note content.
    - `HomePage.dart`: The home page displaying the grid of notes.
    - `addnotepage.dart`: The page for adding and editing notes.
    - `note_widget.dart`: A reusable widget for displaying individual notes.
## Usage

### Adding a Note

1. Tap on the floating action button (`+`) on the home page.
2. Enter the title and content of the note.
3. Tap the save button to save the note.

### Editing a Note

1. Tap on a note to open the edit page.
2. Make the desired changes.
3. Tap the save button to update the note.

### Deleting a Note

1. Long press on a note.
2. Confirm the deletion in the dialog that appears.

### Emotion Detection and Song Recommendations

1. As you type content in the note, emotions are detected automatically.
2. Tap the "Recommend Songs" button to open YouTube with song recommendations based on the detected emotions.

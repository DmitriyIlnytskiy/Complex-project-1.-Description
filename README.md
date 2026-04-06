# Complex-project-1.-Description
App Title: GearShift - Vehicle Maintenance Tracker

Project Goal:
To build a complete, portfolio-ready Flutter application that helps car owners track vehicle maintenance, fuel expenses, and service intervals. This project will demonstrate a clean, multi-screen UI, robust architecture using the BLoC pattern for state management, and a fully integrated Firebase backend (Authentication and Firestore) to handle real-time data and CRUD operations.

List of Features:

User Authentication: Secure email/password login and registration using Firebase Authentication to keep user vehicle data private.

Vehicle Dashboard (UI/UX): A clean, thematic home screen displaying the user's active vehicle profile and a high-level summary of total expenses and recent activity.

Maintenance Log (Data Layer & CRUD): Users can add, view, edit, and delete service records (e.g., oil changes, diagnostics, part replacements). This will utilize Firestore with proper async/await handling, try/catch blocks, and clear loading/error states.

Fuel Expense Tracker: A dedicated section to log fuel fill-ups, calculating fuel efficiency and tracking costs over time.

State-Driven Reminders (State Management): Utilizing BLoC/Cubit to manage the state of upcoming maintenance tasks, alerting the user when a service is due based on inputted mileage or time intervals.

Robust Architecture & Code Quality: The codebase will feature strict separation of concerns (Presentation, Domain, and Data layers), meaningful naming conventions, and no hardcoded values.

Comprehensive Documentation: A detailed README.md outlining the app's purpose, the BLoC architecture flow, and step-by-step setup instructions for running the app and connecting it to Firebase.

Smart Assistant App – Assta 

🚀 Key Features

    Paginated Suggestions: Implements infinite scrolling using the GET /suggestions endpoint. It handles page-based data fetching with integrated loading and error states.

    Interactive Chat UI: A clean, responsive chat interface that simulates real-time interaction with a dummy assistant.

    Persistent Session Management: Features a specialized navigation drawer for managing and switching between chat sessions.

    Reactive State Architecture: Built entirely with Riverpod for predictable, unidirectional data flow and easy testing.

    Declarative Routing: Uses GoRouter for robust navigation management and deep-linking capabilities.

📱 Visual Gallery

<div style="display: flex; flex-wrap: wrap; gap: 15px;">
<div style="flex: 1 1 45%; text-align: center;">
<img src="demo_assets/refresh.gif" alt="Refresh" height="350"/>

<b>Pull to Refresh</b>
</div>
<div style="flex: 1 1 45%; text-align: center;">
<img src="demo_assets/loadmore.gif" alt="Load More" height="350"/>

<b>Infinite Scroll Pagination</b>
</div>
<div style="flex: 1 1 45%; text-align: center;">
<img src="demo_assets/new_chat.gif" alt="New Chat" height="350"/>

<b>Interactive Chat UI</b>
</div>
<div style="flex: 1 1 45%; text-align: center;">
<img src="demo_assets/suggestion_animation.gif" alt="Suggestion" height="350"/>

<b>Polished UI Transitions</b>
</div>
</div>

🛠 Tech Stack & Architecture

    Framework: Flutter (Latest Stable) 

    State Management: Riverpod 

    Navigation: GoRouter 

    Networking: http (Standard library for API consumption) 

    Persistence: Handled via custom session logic 

Project Organization

    The project follows a modular structure to ensure separation of concerns and maintainability:
    Plaintext

    lib/
    ├── api/          # http client and network API abstraction
    ├── model/        # Immutable Data Models (Suggestion, Prompt, Session)
    ├── provider/     # Riverpod providers for business logic and state
    ├── ui/           # Responsive screens and reusable UI components
    └── extension/    # Helper extensions for cleaner Dart code

⚙️ Installation & Setup

    Clone the project:
    git clone [your-repo-url]

    Fetch dependencies:
    flutter pub get

    Run the application:
    flutter run

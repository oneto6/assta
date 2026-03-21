Smart Assistant App – Assta 

🚀 Key Features

    Paginated Suggestions: Implements infinite scrolling using the GET /suggestions endpoint. It handles page-based data fetching with integrated loading and error states.

    Interactive Chat UI: A clean, responsive chat interface that simulates real-time interaction with a dummy assistant.

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

## 📸 Additional Screenshots

Here’s a visual overview of the Smart Assistant App – Assta.  
These screenshots showcase additional features, screens, and interactions in the app.

<div style="
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  align-items: center;
">
  <div style="text-align: center; height: 250px;">
    <img src="demo_assets/history.png" alt="History" style="max-height:100%; width:auto;">
    <b>History</b>
  </div>
  <div style="text-align: center; height: 250px;">
    <img src="demo_assets/prompt_loading.png" alt="Prompt Loading" style="max-height:100%; width:auto;">
    <b>Prompt Loading</b>
  </div>
  <div style="text-align: center; height: 250px;">
    <img src="demo_assets/chat.png" alt="Chat" style="max-height:100%; width:auto;">
    <b>Chat</b>
  </div>

  <div style="text-align: center; height: 250px;">
    <img src="demo_assets/homepage.png" alt="Homepage" style="max-height:100%; width:auto;">
    <b>Homepage</b>
  </div>
  <div style="text-align: center; height: 250px;">
    <img src="demo_assets/new_chat.png" alt="New Chat" style="max-height:100%; width:auto;">
    <b>New Chat</b>
  </div>
  <div style="text-align: center; height: 250px;">
    <img src="demo_assets/prompt_reply.png" alt="Prompt Reply" style="max-height:100%; width:auto;">
    <b>Prompt Reply</b>
  </div>
</div>

🛠 Tech Stack & Architecture

    Framework: Flutter (Latest Stable) 

    State Management: Riverpod 

    Navigation: GoRouter 

    Networking: http (Standard library for API consumption) 


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
    git clone git clone https://github.com/oneto6/assta.git

    Fetch dependencies:
    flutter pub get

    Run the application:
    flutter run

🌐 Live Preview

    You can check out the live GitHub Pages version of the app here:
    https://oneto6.github.io/assta/

## 📥 Download & Releases

    You can download the latest **Android APK** or other build artifacts from the GitHub Releases page:

    [**Download Latest Release**](https://github.com/oneto6/assta/releases)

    > Note: The releases section contains pre-built binaries for easy installation.  
    > For source code and building from scratch, see the instructions above.

# Photo Album App

## Overview

The **Photo Album App** is a high-performance image gallery that efficiently loads and displays around **30,000 images** from a placeholder API (e.g., [Picsum Photos](https://jsonplaceholder.typicode.com/photos)). The app ensures smooth scrolling using **lazy loading and pagination** while providing a **search functionality** to filter images based on title or ID. The UI is designed using a modern framework to offer a clean and user-friendly experience.

## Features

- **High-performance image loading**: Handles up to **30,000 images** efficiently.
- **Lazy loading & pagination**: Ensures smooth scrolling performance.
- **Section headers** (optional sticky headers) for better organization.
- **Search functionality**: Filter images by title or ID.
- **Graceful error handling**: Displays proper messages in case of network failures.
- **Modern UI**: Built using a modern UI framework for an optimized user experience.

## Technologies Used

- **Frontend Framework**: (React/Flutter/Jetpack Compose - Specify which one you used)
- **State Management**: (Provider/Redux/Riverpod, etc.)
- **Networking**: Fetch API / Dio / Retrofit (Mention your choice)
- **Pagination & Lazy Loading**: (Infinite Scroll, RecyclerView, etc.)
- **Error Handling**: Toasts, Snackbars, or Custom UI Alerts

## API Used

Images are fetched from [Picsum Photos](https://jsonplaceholder.typicode.com/photos), a free image placeholder service.

## Installation & Setup

### Prerequisites

- Ensure you have **Node.js / Flutter / Android Studio** installed (based on your tech stack).
- Clone the repository:
  ```sh
  git clone https://github.com/vishwatejaavaerager/photo_album-app.git
  ```
- Navigate to the project directory:
  ```sh
  cd photo-album-app
  ```
- Install dependencies:
  ```sh
  npm install / flutter pub get
  ```

### Running the App

```sh
flutter run
```

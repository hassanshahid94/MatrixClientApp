# MatrixClientApp

A lightweight SwiftUI client for interacting with a Matrix homeserver.
The app includes login, room listing, joining rooms, and viewing messages.

---

## Table of Contents

* [Overview](#overview)
* [Architecture](#architecture)
* [ViewModels](#viewmodels)
* [Managers / Services](#managers--services)
* [Models](#models)
* [Networking](#networking)
* [Room Flow](#room-flow)
* [Unit Tests](#unit-tests)
* [Improvements](#improvements)

---

## Overview

This project demonstrates communication with a Matrix server using Swift Concurrency (`async/await`).
It includes login handling, room list loading, joining rooms, and fetching initial messages from a room.

---

## Architecture

The project follows the MVVM pattern with service layers handling all Matrix API interaction.

---

## ViewModels

### **LoginViewModel**

* Handles user login.
* Sends credentials to the Matrix login endpoint.
* Stores the access token securely.
* Notifies the app when login is successful.

### **HomeViewModel**

* Loads all public rooms from the homeserver.
* Loads joined rooms if available.
* Supports logout (clears access token).

### **RoomDetailViewModel**

* Checks whether the user already joined the requested room.
* If not joined → shows a **“Join Room”** button.
* If joined → loads the room’s messages.
* Uses `MessageManager` to fetch timeline events.
* Stores messages grouped by day for the UI.

---

## Managers / Services

### **AuthenticationManager**

* Handles login request.
* Saves and provides access token for authenticated requests.

### **RoomManager**

* Loads public rooms.
* Loads all joined rooms.
* Sends request to **join** a room.
* Provides room metadata if needed.

### **MessageManager (MessageManagerImp)**

* Fetches message timeline for a room.
* Uses the Matrix `/rooms/{roomId}/messages` endpoint.
* Parses raw Matrix events into:

  * `MessageEvent`
  * `MembershipEvent`
* Returns a list of `TimelineEvent` objects.

---

## Models

### **MessageEvent**

Represents a text message with id, sender, display name, timestamp, and formatted date.

### **MembershipEvent**

Represents join / leave / invite actions with id, sender, and timestamp.

### **TimelineEvent**

Enum combining `MessageEvent` and `MembershipEvent`.

Includes helper properties:

* `id`
* `date`

### **Grouping Extensions**

`Array<TimelineEvent>.groupedByDay()` groups messages by date for the UI.

---

## Networking

All HTTP communication goes through **WebService**.

* Uses async/await.
* Injects authorization header when access token is available.
* Decodes JSON into typed models.
* Handles errors and logs responses.

---

## Room Flow

1. **Login**

   * User enters username/password → receives access token.

2. **Home Screen**

   * Loads all public rooms.
   * Loads user's joined rooms.
   * Logout available.

3. **Room Detail Screen**

   * ViewModel checks if user is already joined.
   * If not joined → shows Join button.
   * After joining → loads message timeline.
   * Displays membership events and messages.

4. **Message Loading**

   * `MessageManagerImp` loads room timeline once.
   * Messages appear grouped by day.

---

## Unit Tests

The project includes unit tests for both services and view models:

* **AuthenticationManagerTests**: verifies login logic, token storage, and error handling.
* **RoomManagerTests**: tests public rooms fetching, joined rooms, and join room functionality.
* **MessageManagerTests**: ensures message fetching, event parsing, and timeline creation.
* **LoginViewModelTests**: checks login flow, token saving, and error propagation.
* **HomeViewModelTests**: validates room loading, joined room logic, and logout.
* **RoomDetailViewModelTests**: tests joining rooms, fetching messages, and timeline grouping.

Tests are written using XCTest and mock services to isolate network calls.

---

## Improvements

* Live message updates using the Matrix `/sync` API (no AsyncStream yet).
* Sending messages using Matrix send API.
* Leaving a room.
* Refresh token handling.
* Pagination for older messages.

---

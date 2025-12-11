# Send Money App — Design Document

## Overview
The goal is to crete an application that simulates a digital wallet where users can log in with a predefined demo account, view their wallet balance, send money, and see transaction history.

---

## Architecture

### Core Pattern: MVVM + Central DataStore
`DataStore` is the single source of truth for:
- Authentication and session state management
- Wallet balance
- SwiftData persistence
- Network services

Views and view models depend on `DataStore` rather than talking to services directly.

### Layers
- **View**  
  SwiftUI presentation, reacts to `@EnvironmentObject DataStore`.

- **ViewModel**  
  Input validation and UI-specific state.  
  Calls `DataStore` for actual operations.

- **DataStore**  
  Business logic layer.  
  Orchestrates services and persistence.

- **Services**
  - `AuthService` — handles credential validation and executes the authentication API call to obtain a session token.
  - `WalletService` — fetches transaction DTOs(Data Transfer Object)
  - `SessionStore` — persists login token  
  - `WalletStore` — persists wallet balance  
  - `SwiftData` — stores `Transaction` models  

### Persistence
- **SwiftData** stores all created transactions.
- **WalletStore** — persists the wallet balance. This project uses a concrete `DefaultsWallet` implementation backed by `UserDefaults`.
- **SessionStore** — persists the login token. This project uses a concrete `KeychainSession` implementation backed by the iOS Keychain.
- `AppConfig` provides initial values (e.g., initial balance and baseURL).

### API Layer
- **APIService**  
  High-level client that builds requests, retrieves raw data through a data source,
  and decodes responses into typed models.

- **APIDataSource**  
  Low-level provider responsible for fetching raw `Data`.  
  Enables swapping between real network calls, local data retrievals, or mocks without
  changing app logic.

---

## Key Flows

### Login
1. User enters username/password  
2. `AuthService` validates  
3. `DataStore` stores token via `SessionStore`  
4. UI switches to dashboard

### Send Money
1. `SendMoneyViewModel` validates amount  
2. `SendMoneyViewModel` calls `DataStore.sendMoney(amount:)`  
3. DataStore:
   - Creates and saves a Transaction (SwiftData)
   - Deducts balance + persists new balance  
4. `SendMoneyViewModel` updates UI(Dashboard) with result

### Fetch Transactions
1. `TransactionHistoryViewModel` triggers a fetch through `WalletService`.
2. `WalletService.fetchTransactionHistory()` returns a list of transaction DTOs.
3. `DataStore` upserts each DTO into SwiftData (create or update).
4. `DataStore` returns all stored transactions, sorted by newest first, back to the `TransactionHistoryViewModel`.

---

## Mock API Setup (Postman)

This project uses two Postman mock endpoints to simulate backend behavior.

### **1. `/transactions`**
Returns the mock transaction list used by the app.

- **GET `/transactions`** → **200 OK**  
  Returns an array of `TransactionDTO` objects.

### **2. `/auth`**
Simulates authentication behavior.

- **POST `/auth`** → **401 Unauthorized**  
  Always fails. Used to enforce that only the demo user can authenticate.

- **POST `/auth/demo`** → **200 OK**  
  Returns a mock token for the demo user.  
  (NOTE: `demo` is the only valid username in this app.)

---

## Test Coverage

### Authentication

#### AuthService
- `test_authenticate_success_returnsToken` - returns token on valid credentials.
- `test_authenticate_unauthorized_throwsError` - throws on invalid credentials.

#### DataStore
- `test_authenticate_success` - sets authenticated state + saves token.
- `test_authenticate_unauthorized` - remains unauthenticated on failure.
- `test_logout_sets_isAuthenticated_false` - clears session + logs out.
- `test_loadSession_whenTokenExists` - restores authenticated state.
- `test_loadSession_whenNoToken` - remains logged out.

---

### Send Money

#### DataStore
- `test_sendMoney_success` - creates transaction + updates balance.
- `testSendMoney_failure` - fails without updating balance.

#### ViewModel
- `testSendMoney_whenAmountIsInvalid` - rejects invalid input.
- `testSendMoney_whenAmountIsGreaterThanBalance` - rejects amount > balance.
- `testSendMoney_whenAmountIsZero` - rejects zero amount.
- `testSendMoney_whenAmountIsNegative` - rejects negative amount.
- `testSendMoney_success_createsTransactionAndUpdatesVM` - updates UI + returns transaction.

---

## Limitations / Simplifications
- Only one demo user can log in (`AUTH_USERNAME`).
- Networking is real, but all endpoints point to a Postman mock server (no production backend).
- Minimal UI styling; focus is on functionality and architecture.



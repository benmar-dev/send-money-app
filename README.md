# Send Money App (iOS)

A simple SwiftUI demo app that lets a user log in, view their wallet balance, send money, and store transactions locally.

## Features
- Demo login (only the configured username is allowed)
- Wallet balance and transaction history with persistent storage
- Send money flow with full validation
- MVVM + DataStore architecture
- Dependency-injected services for testability
- Unit tests for DataStore and ViewModels

See the full design document **[here](doc/Design.md)**  

## Requirements
- Xcode 15+
- iOS 17+
- SwiftData-enabled device or simulator

## Run Instructions
1. Clone the repository  
2. Open `MayaExam.xcodeproj`  
3. Build & run (`⌘R`)  
4. Log in using the demo credentials: NOTE: all other username and passwords are not accepted.
   - **Username:** `demo`  
   - **Password:** `pass`

## Project Structure
- `DataStore` — central business/state manager  
- `ViewModels` — validation + UI logic  
- `Network Services` — Auth, Wallet
- `Storage Services` — Session, WalletStore  
- `Models` — SwiftData, Data-Transfer-Object models  
- `Views` — SwiftUI screens  
- `Config` — AppConfig, SwiftDataConfig, AuthConfig and xcconfig files  
- `Tests` — DataStore + ViewModel unit tests  


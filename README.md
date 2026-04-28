# TowerForge

A real-time multiplayer tower defense game built with Swift and pure UIKit for iPad — no SpriteKit or third-party game engines. The project emphasizes software engineering principles by implementing a custom game loop, rendering pipeline, and ECS framework from scratch using only UIKit.

## Features

- **Three Game Modes** — Death Match, Capture the Flag, and Survival (wave-based PvE)
- **Online Multiplayer** — Real-time state synchronization via Firebase Realtime Database with remote event publishing/subscribing
- **Progression System** — Player statistics, achievements (kill/damage milestones), missions, and a global leaderboard
- **Power-ups** — Invulnerability, damage boost, and no-cost abilities with in-game activation
- **Multiple Unit Types** — Soldiers, wizards, archers, melee units, and towers with distinct attack patterns and projectiles

## Architecture

The game is built on a custom **Entity-Component-System (ECS)** framework with an **event-driven** simulation layer:

```
┌─────────────────────────────────────────────────┐
│                   GameEngine                    │
│  ┌─────────────┐  ┌────────────┐  ┌───────────┐ │
│  │SystemManager│  │EventManager│  │ GameMode  │ │
│  │  (ECS loop) │  │  (queued)  │  │ (rules)   │ │
│  └──────┬──────┘  └─────┬──────┘  └───────────┘ │
│         │               │                       │
│  ┌──────▼──────┐  ┌─────▼──────────────────┐    │
│  │  Systems    │  │  Events                │    │
│  │ Health      │  │ DamageEvent, KillEvent,│    │
│  │ Movement    │  │ SpawnEvent, RemoteSync,│    │
│  │ Spawn       │  │ PowerupEvent, ...      │    │
│  │ Shooting    │  └─────┬──────────────────┘    │
│  │ Contact     │        │                       │
│  │ AI          │  ┌─────▼──────────────────┐    │
│  └─────────────┘  │ RemoteEventManager     │    │
│                   │ (Firebase pub/sub)     │    │
│                   └────────────────────────┘    │
└─────────────────────────────────────────────────┘
```

- **Entities** (`TFEntity`) are composed of **Components** (`TFComponent`) — health, position, movement, sprites, etc.
- **Systems** (`TFSystem`) operate on entities each frame — `HealthSystem`, `MovementSystem`, `SpawnSystem`, `ShootingSystem`, `ContactSystem`, `AiSystem`, etc.
- **Events** are queued and executed per frame, supporting transformations and concurrent events. Remote events are serialized and synced via Firebase for multiplayer.
- **Rendering** uses a custom staged pipeline (`RenderStage`) built on pure UIKit, decoupling game logic from visual updates without relying on SpriteKit or any game framework.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift |
| UI | Pure UIKit (menus + gameplay — no SpriteKit) |
| Networking | Firebase Realtime Database, Firebase Auth |
| Architecture | Custom ECS + Event-Driven |
| Build | Xcode, Swift Package Manager |
| CI | GitHub Actions (xcodebuild on iPad simulator) |
| Linting | SwiftLint |

### Design Philosophy

The project deliberately avoids SpriteKit and third-party game engines. The game loop, rendering pipeline, collision detection, and entity management are all implemented from scratch using UIKit. This constraint was a core requirement of CS3217 to demonstrate software engineering fundamentals — architecture, design patterns, and clean abstractions — rather than reliance on framework features.

## Getting Started

### Prerequisites
- macOS with Xcode installed
- iOS SDK (iPad simulator or physical device)

### Build & Run
1. Clone the repository
2. Open `TowerForge/TowerForge.xcodeproj` in Xcode
3. SPM dependencies (Firebase SDK) will resolve automatically on first open
4. Select the **TowerForge** scheme and an iPad simulator
5. Build and run (`Cmd + R`)

> **Note:** The app uses a shared Firebase project for multiplayer and leaderboards. To use your own backend, replace `GoogleService-Info.plist` with your Firebase project config.

## Team

Built by a team of 4 for NUS CS3217 (Software Engineering on Modern Application Platforms), AY2023/24 Semester 2.

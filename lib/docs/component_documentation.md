# KRPG Mobile Component System Documentation

This document provides a comprehensive overview of the reusable components created for the SiMenang KRPG mobile application, based on the web application's UI patterns but optimized for mobile use.

## Table of Contents

1. [Introduction](#introduction)
2. [Component Checklist](#component-checklist)
3. [Card Components](#card-components)
4. [Button Components](#button-components)
5. [Badge Components](#badge-components)
6. [Training Components](#training-components)
7. [Competition Components](#competition-components)
8. [Best Practices](#best-practices)

## Introduction

The KRPG component system is designed to provide a consistent user experience across the mobile application while maintaining visual coherence with the web application. The components are built to be:

- **Reusable**: Components can be used across different screens
- **Flexible**: Components accept various parameters for customization
- **Consistent**: Components follow the same design language
- **Accessible**: Components are designed with accessibility in mind
- **Performant**: Components are optimized for mobile performance

## Component Checklist

Below is a checklist of all the components that have been implemented:

- [x] **Card Components**
  - [x] KRPGCard (Base card component)
  - [x] KRPGCard.dashboard (Dashboard card variant)
  - [x] KRPGCard.statistic (Statistics card variant)
  - [x] KRPGCard.list (List item card variant)
  - [x] KRPGCard.training (Training card variant)
  - [x] KRPGCard.competition (Competition card variant)

- [x] **Button Components**
  - [x] KRPGButton (Base button component)
  - [x] KRPGButton.primary (Primary button variant)
  - [x] KRPGButton.secondary (Secondary button variant)
  - [x] KRPGButton.success (Success button variant)
  - [x] KRPGButton.danger (Danger button variant)
  - [x] Button sizes (small, medium, large)
  - [x] Button states (default, loading, disabled)
  - [x] Button types (filled, outlined, text)

- [x] **Badge Components**
  - [x] KRPGBadge (Base badge component)
  - [x] KRPGBadge.success (Success badge variant)
  - [x] KRPGBadge.warning (Warning badge variant)
  - [x] KRPGBadge.danger (Danger badge variant)
  - [x] KRPGBadge.info (Info badge variant)
  - [x] KRPGBadge.neutral (Neutral badge variant)

- [x] **Training Components**
  - [x] TrainingCard (Training card component)

- [x] **Competition Components**
  - [x] CompetitionCard (Competition card component)

## Card Components

### KRPGCard

The base card component that provides a foundation for all card variants.

**Usage:**

```dart
KRPGCard(
  child: Text('Card content'),
  backgroundColor: Colors.white,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  borderRadius: BorderRadius.circular(12),
  elevation: 2,
  onTap: () => print('Card tapped'),
)
```

**Variants:**

1. **KRPGCard.dashboard**: Used for dashboard summary cards
2. **KRPGCard.statistic**: Used for statistic display cards
3. **KRPGCard.list**: Used for list items
4. **KRPGCard.training**: Used for training items
5. **KRPGCard.competition**: Used for competition items

## Button Components

### KRPGButton

The base button component that provides a foundation for all button variants.

**Usage:**

```dart
KRPGButton(
  text: 'Button Text',
  onPressed: () => print('Button pressed'),
  type: KRPGButtonType.filled,
  size: KRPGButtonSize.medium,
  backgroundColor: Colors.blue,
  textColor: Colors.white,
  icon: Icons.add,
  isLoading: false,
  isFullWidth: false,
)
```

**Types:**
- `KRPGButtonType.filled`: Filled background button
- `KRPGButtonType.outlined`: Outlined button with transparent background
- `KRPGButtonType.text`: Text-only button with no background or border

**Sizes:**
- `KRPGButtonSize.small`: Small button (36px height)
- `KRPGButtonSize.medium`: Medium button (44px height)
- `KRPGButtonSize.large`: Large button (52px height)

**Variants:**
1. **KRPGButton.primary**: Primary action button (blue)
2. **KRPGButton.secondary**: Secondary action button (outlined blue)
3. **KRPGButton.success**: Success action button (green)
4. **KRPGButton.danger**: Danger action button (red)

## Badge Components

### KRPGBadge

The base badge component used for status indicators and labels.

**Usage:**

```dart
KRPGBadge(
  text: 'Badge Text',
  backgroundColor: Colors.blue.withOpacity(0.1),
  textColor: Colors.blue,
  fontSize: 12,
  icon: Icons.info,
  borderRadius: BorderRadius.circular(8),
)
```

**Variants:**
1. **KRPGBadge.success**: Success status badge (green)
2. **KRPGBadge.warning**: Warning status badge (orange)
3. **KRPGBadge.danger**: Danger status badge (red)
4. **KRPGBadge.info**: Information badge (blue)
5. **KRPGBadge.neutral**: Neutral badge (grey)

## Training Components

### TrainingCard

A specialized card component for displaying training information.

**Usage:**

```dart
TrainingCard(
  training: trainingObject,
  onTap: () => print('Training card tapped'),
  onStartTraining: () => print('Start training'),
  onViewDetails: () => print('View training details'),
  showActions: true,
  isCompact: false,
)
```

**Features:**
- Displays training title, coach, date, time, and location
- Shows training status badge
- Indicates if training can be started today
- Provides action buttons for starting training and viewing details
- Supports compact mode for list views

## Competition Components

### CompetitionCard

A specialized card component for displaying competition information.

**Usage:**

```dart
CompetitionCard(
  competition: competitionObject,
  onTap: () => print('Competition card tapped'),
  onRegister: () => print('Register for competition'),
  onViewDetails: () => print('View competition details'),
  showActions: true,
  isCompact: false,
  participation: participationObject, // Optional
)
```

**Features:**
- Displays competition name, organizer, date, location, and prize
- Shows competition status badge
- Indicates if registration is open
- Shows participation status if the user is registered
- Displays competition level badge
- Provides action buttons for registering and viewing details
- Supports compact mode for list views

## Best Practices

1. **Use Factory Constructors**: Use the provided factory constructors for common use cases to maintain consistency.
2. **Responsive Design**: Ensure components adapt to different screen sizes by using flexible layouts.
3. **Consistent Spacing**: Maintain consistent spacing between components (8px, 16px, 24px increments).
4. **Color Usage**: Follow the color scheme defined in the theme for consistency.
5. **Typography**: Use the typography styles defined in the theme.
6. **Icons**: Use Material Icons for consistency across the app.
7. **Loading States**: Always provide feedback during asynchronous operations using loading states.
8. **Error Handling**: Handle errors gracefully and provide clear error messages.
9. **Accessibility**: Ensure components are accessible by using proper contrast, touch targets, and semantic labels.
10. **Performance**: Optimize components for performance by avoiding unnecessary rebuilds.

---

This component system is designed to be extended as needed. New components should follow the same patterns and principles outlined in this documentation. 
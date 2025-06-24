# KRPG Design System Documentation

This document provides comprehensive documentation for the SiMenang KRPG design system, which ensures consistent UI/UX across the mobile application.

## Table of Contents

1. [Introduction](#introduction)
2. [Theme](#theme)
   - [Colors](#colors)
   - [Typography](#typography)
   - [Spacing](#spacing)
   - [Shadows](#shadows)
   - [Border Radius](#border-radius)
3. [Components](#components)
   - [Buttons](#buttons)
   - [Cards](#cards)
   - [Badges](#badges)
   - [Form Fields](#form-fields)
   - [Layout](#layout)
   - [Model Components](#model-components)
4. [Usage Guidelines](#usage-guidelines)
5. [Best Practices](#best-practices)

## Introduction

The KRPG Design System is a collection of reusable components, styles, and guidelines that ensure consistency and cohesion across the SiMenang KRPG mobile application. This design system mirrors the web application's design patterns while optimizing for mobile use.

## Theme

### Colors

The color system is organized into brand colors, semantic colors, and neutral colors:

#### Brand Colors
- **Primary Color**: `#2563EB` - Blue 600 - Used for primary actions, navigation, and key UI elements
- **Secondary Color**: `#10B981` - Emerald 500 - Used for secondary actions and accents
- **Accent Color**: `#F97316` - Orange 500 - Used for highlights and special elements

#### Semantic Colors
- **Success**: `#10B981` - Emerald 500 - Used for success states and positive actions
- **Warning**: `#F59E0B` - Amber 500 - Used for warnings and cautionary states
- **Danger**: `#EF4444` - Red 500 - Used for errors and destructive actions
- **Info**: `#3B82F6` - Blue 500 - Used for informational states

#### Neutral Colors
- **Dark**: `#1F2937` - Gray 800 - Used for headings and important text
- **Medium**: `#6B7280` - Gray 500 - Used for secondary text and icons
- **Light**: `#F3F4F6` - Gray 100 - Used for backgrounds and dividers

### Typography

Typography is organized into a clear hierarchy:

#### Headings
- **Heading 1**: 36px, Bold, -0.5 letter spacing
- **Heading 2**: 30px, Bold
- **Heading 3**: 24px, Bold
- **Heading 4**: 20px, Semi-Bold
- **Heading 5**: 18px, Semi-Bold
- **Heading 6**: 16px, Semi-Bold

#### Body Text
- **Body Large**: 16px, Regular
- **Body Medium**: 14px, Regular
- **Body Small**: 12px, Regular

#### Labels
- **Label Large**: 14px, Medium, 0.25 letter spacing
- **Label Medium**: 12px, Medium, 0.25 letter spacing

#### Button Text
- **Button Large**: 16px, Medium
- **Button Medium**: 14px, Medium
- **Button Small**: 12px, Medium

#### Special Text
- **Card Title**: 16px, Semi-Bold
- **Card Subtitle**: 14px, Regular, Medium color
- **Stat Number**: 24px, Bold
- **Stat Label**: 12px, Medium, Medium color

### Spacing

Spacing is consistent throughout the application:

- **XXS**: 2px
- **XS**: 4px
- **SM**: 8px
- **MD**: 16px
- **LG**: 24px
- **XL**: 32px
- **XXL**: 48px

### Shadows

Three levels of elevation are used:

- **Small**: 0px 1px 2px rgba(0, 0, 0, 0.05)
- **Medium**: 0px 2px 4px rgba(0, 0, 0, 0.05)
- **Large**: 0px 4px 10px rgba(0, 0, 0, 0.1)

### Border Radius

Consistent border radius values:

- **XS**: 4px
- **SM**: 8px
- **MD**: 12px
- **LG**: 16px
- **XL**: 24px
- **Round**: 9999px (for fully rounded elements)

## Components

### Buttons

#### Variants
- **Primary**: Blue background with white text
- **Secondary**: Green background with white text
- **Success**: Green background with white text
- **Warning**: Amber background with white text
- **Danger**: Red background with white text
- **Info**: Blue background with white text

#### Styles
- **Filled**: Solid background color
- **Outline**: Transparent background with colored border
- **Icon Only**: Square button with just an icon

#### Sizes
- **Large**: 48px height, 16px font
- **Medium**: 40px height, 14px font
- **Small**: 32px height, 12px font

#### States
- **Default**: Normal state
- **Hover**: Slightly darker
- **Pressed**: Even darker
- **Loading**: Shows a spinner
- **Disabled**: Grayed out, not clickable

### Cards

#### Variants
- **Basic**: Simple card with subtle shadow
- **Dashboard**: Slightly elevated card for dashboard widgets
- **List**: Card optimized for list items with tap interaction
- **Stats**: Card for displaying statistics
- **Training**: Specialized card for training information
- **Competition**: Specialized card for competition information

#### Properties
- **Shadow**: Medium shadow by default
- **Border Radius**: 12px (MD)
- **Padding**: 16px (MD) by default

### Badges

#### Variants
- **Default**: Primary color
- **Success**: Success color
- **Warning**: Warning color
- **Danger**: Danger color
- **Info**: Info color
- **Neutral**: Medium neutral color

#### Properties
- **Border Radius**: 9999px (fully rounded)
- **Font Size**: 12px by default
- **Padding**: 4px 8px by default

### Form Fields

#### Text Fields
- **Default**: Regular text input
- **Password**: Password input with visibility toggle
- **Multiline**: Text area for longer text
- **Disabled**: Grayed out, not editable
- **Error**: Red border and error message
- **With Helper**: Helper text below the field

#### Dropdowns
- **Default**: Regular dropdown
- **With Icons**: Dropdown items with icons
- **Disabled**: Grayed out, not selectable
- **Error**: Red border and error message

#### Properties
- **Border Radius**: 8px (SM)
- **Border Color**: Light neutral by default, primary when focused
- **Label**: Above the field
- **Required Indicator**: Red asterisk

### Layout

#### App Bar
- **Primary**: Blue background with white text
- **Secondary**: Green background with white text
- **Transparent**: No background, dark text
- **Light**: White background, dark text

#### Scaffold
- **Primary**: Blue app bar
- **Secondary**: Green app bar
- **Light**: White app bar, dark text

#### Properties
- **Safe Area**: Respects device safe areas
- **Padding**: Consistent edge padding
- **Loading Overlay**: Semi-transparent overlay with spinner

### Model Components

#### Athlete Card
- Displays athlete information
- Shows status, level, specializations
- Action buttons for profile and achievements

#### Coach Card
- Displays coach information
- Shows status, specialization, certifications
- Action buttons for profile and schedule

#### Training Card
- Displays training information
- Shows time, location, coach
- Action buttons for details and attendance

#### Competition Card
- Displays competition information
- Shows dates, location, registration deadline
- Action buttons for details and registration

## Usage Guidelines

1. **Consistency**: Always use components from the design system rather than creating custom ones.
2. **Hierarchy**: Use typography and spacing to establish clear visual hierarchy.
3. **Accessibility**: Ensure sufficient color contrast and touch target sizes.
4. **Responsiveness**: Use responsive spacing and layouts to adapt to different screen sizes.
5. **Simplicity**: Keep interfaces clean and focused on essential elements.

## Best Practices

1. **Import the Design System**: Import the design system barrel file:
   ```dart
   import 'package:simenang_krpg/design_system/krpg_design_system.dart';
   ```

2. **Use Theme Constants**: Access theme constants directly:
   ```dart
   color: KRPGTheme.primaryColor,
   style: KRPGTextStyles.bodyMedium,
   padding: KRPGSpacing.paddingMD,
   ```

3. **Use Component Factories**: Use factory constructors for variants:
   ```dart
   KRPGButton.secondary(
     text: 'Secondary Button',
     onPressed: () {},
   )
   ```

4. **Consistent Spacing**: Use the spacing constants for layout:
   ```dart
   Column(
     children: [
       Text('Heading'),
       KRPGSpacing.verticalMD,
       Text('Content'),
     ],
   )
   ```

5. **Responsive Considerations**: Use responsive helpers for different screen sizes:
   ```dart
   padding: KRPGSpacing.getResponsivePadding(context),
   ``` 
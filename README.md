# Shopping List App (COMP3079 Project)
![image](https://github.com/user-attachments/assets/5398a668-db37-4e14-904a-d73119b2d27a)
<br><br>
![image](https://github.com/user-attachments/assets/f215f744-f7d8-404a-9767-5ea65beda355)

## Overview
Shopping List App is a SwiftUI-based application designed to help users manage their shopping lists in an organized manner. Users can create folders, add categories, and enter shopping items within each category. The app automatically calculates taxes based on Ontario Canadian law.


## Figma
https://www.figma.com/design/uzYPPIDsKlK6yyUuLkDHk8/IOS-GBC-Project?node-id=0-1&t=aUvshnSWeCkuVTiV-1


## Key Features
- **Folder & Category Management**
  - Create folders and add multiple categories within each folder.
  - Categories appear as collapsible dropdown sections.
  - Edit and delete categories via a three-dot menu.

- **Item Management**
  - Add new items to categories with details such as name and price.
  - Select the item type (Food, Medication, Cleaning, Other) using a segmented picker.
  - Automatic tax calculation:
    - **Food**: No tax.
    - **Medication**, **Cleaning**, **Other**: 13% HST.
  - Display individual item details including price, calculated tax, and total price.
  - Delete individual items using an "X" button.

- **User Interface**
  - **Top Bar**: Back button, “EZ list” logo, and “+ Category” button.
  - **Category Dropdown**: Each category is displayed as a dropdown title (e.g., "Grocery") that expands to show the item list and totals.
  - **Add New Item Modal**: When tapping "Add New Item," a modal sheet appears with input fields and a segmented picker for category selection.
  - **Bottom Navigation**: A rounded navigation bar with Home, List, and Settings tabs, where the active tab is highlighted in blue.

- **Data Persistence**
  - Data is saved using UserDefaults (keyed by folder name) so that all folders, categories, and items persist between app launches.

## Usage

1. **Folder Selection**  
   From the HomeView, select a folder to navigate to the Shopping List screen.

2. **Category Management**  
   - Tap the “+ Category” button in the top bar to add a new category.
   - Each category appears as a dropdown; tap the arrow to expand or collapse the category.
   - Use the three-dot menu to edit or delete a category.

3. **Item Management**  
   - Within an expanded category, tap the “Add New Item” button to open the modal.
   - In the modal, enter the item’s name and price, and select its type using the segmented picker (Food, Medication, Cleaning, Other).
   - After tapping “Add Item,” the item is added to the category list with its price, tax, and total calculated automatically.

4. **Navigation**  
   Use the bottom navigation bar to switch between Home, List, and Settings screens.

## Installation

1. Clone or download the project repository.
2. Open the project in Xcode.
3. Build and run the project on an iOS Simulator or a physical device.

## License
This project is developed as part of the COMP3079 project.

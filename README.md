# ConnectCard

ConnectCard is a mobile application that allows users to scan, store, and manage their name cards digitally. Designed for recruiters, professionals, job seekers, and everyone else. Simplify networking, all in one place.

# Level of achievement
Apollo II

## Description

ConnectCard utilizes Firebase for data storage and manipulation, and Flutter for the user interface design. It offers various features such as scanning and storing name card information, linking the app to communication platforms like Telegram, Whatsapp, Phone, and Email, updating existing data, NFC technology for easy name card exchange, and a membership/reward card feature.

### Problem:

Carrying physical name cards and membership/loyalty cards can be burdensome, leading to lost contact information and a cluttered wallet. It is inconvenient for individuals who meet new people, engage in business interactions, or collect various membership cards to manage and access these cards efficiently.

### Need:

Currently, there are existing name card applications that provide features such as storing and managing digital name cards of self and others. However, there are some few applications that satisfy some features that are important in a digital name card application.

Existing name card applications have limited functionality in these areas
Converting current physical name cards into digital name cards easily
Sharing digital name cards with others easily
Store and access membership or loyalty reward cards digitally, eliminating the reliance on physical cards.

### Solution:

ConnectCard provides a convenient solution by allowing users to scan physical name cards using their phone camera and convert them into digital cards stored within the application. Users can easily update their personal digital name cards, keeping their contact information up to date for seamless interactions. The application also enables users to exchange digital name cards effortlessly, through sending it through a link and using NFC technology. Furthermore, users can store and track their membership or loyalty reward cards digitally, while vendors can update customers' progress in real-time. With our app, individuals can simplify their wallet, stay connected with ease, and take full advantage of membership benefits without the hassle of physical cards.

## User Stories
1. As a recruiter, I want to easily scan and store name cards digitally, so that I can manage and access contact information efficiently during the hiring process.

2. As a working adult, I want to update my personal digital name card easily, so that I can keep my contact information up to date for seamless interactions with clients and colleagues.

3. As a job seeker, I want to quickly exchange my digital name card with potential employers or networking contacts using NFC technology, so that I can make a lasting impression and enhance my job prospects.

4. As a user, I want to link the ConnectCard app to popular communication platforms like Telegram, Whatsapp, Phone, and Email, so that I can easily connect with my contacts.

5. As a business owner, I want to store and access my customers' membership or loyalty reward cards digitally, so that I can eliminate the reliance on physical cards and provide a convenient way for customers to access their rewards.

6. As a user, I want to convert my physical membership or milestone reward cards into digital versions, so that I can simplify my wallet and take full advantage of loyalty programs without the hassle of carrying physical cards.

7. As a user, I want to easily share my digital name card with others by sending a link, so that I can quickly exchange contact information and foster professional relationships.

## Features

### The following functionality is complete:
**Phase 1**

1. [x] **UI/UX of Application:** Finalized the design using FIGMA to be used as a template to guide

2. [x] **Login / Registration:** By using an email & password to login

### The following functionality is incomplete:

**Phase 2**
1. [X] **Database:** The app uses Firebase as the backend database to store and manipulate data, ensuring efficient data management and retrieval. 

2. [X] **Updating existing Data:** Users have the flexibility to update their personal digital name cards at any time. This feature is especially useful when users experience changes in their job positions or roles within their existing company.

3. [X] **Scanning and Storing Feature:** Users can use their device's camera to scan name cards and extract relevant information. The extracted information is then stored in the Firebase database, allowing easy access and reference.

**Phase 3**
1. [] **Friends system** The app uses Firebase as a backend database to store friend's card.

2. [] **Communication Integration:** The app seamlessly integrates with popular communication platforms such as Telegram, Whatsapp, Phone, and Email. This enables users to easily connect with their clients directly from the app.

3. [] **NFC Technology for Name Card Exchange:** The app leverages NFC technology to facilitate the exchange of digital name cards between users. By simply tapping their phones together, users can transfer their digital name cards conveniently.

4. [] **Membership/Reward Card Feature:** Users can convert their physical membership or milestone reward cards into digital versions. Vendors can access and update users' progress using the app, providing a seamless and centralized way to manage loyalty programs.

## Poster & Video

To watch the video of ConnectCard & view the poster, click the following link!

**LiftOff**

Elevator Pitch Video: https://drive.google.com/file/d/1KqCCN2fL1QiHnOnuNatBzYJn6tmiY9W4/view?usp=share_link

Poster: https://drive.google.com/file/d/1Xfcv88yRIS-P9JojkY_17qMARUUyWp3c/view?usp=share_link

**Milestone 1**

Figma Design: https://www.figma.com/file/hVvHnTKv5smJBOPmTPnpZP/Connect-Card?type=design&node-id=0%3A1&t=8YLkiicqGAFXCIrQ-1

Project Demo: https://drive.google.com/file/d/1_FYtio2JPChTIyvzL8KLP-Jp_Hdezmzm/view?usp=sharing

Milestone 1 Prototype: https://drive.google.com/file/d/1_FYtio2JPChTIyvzL8KLP-Jp_Hdezmzm/view?usp=sharing

**Milestone 2**

A1 Poster:

Project Demo:

Try it yourself:

## Key Technologies

**Optical Character Recognition (OCR)**

ConnectCard utilizes OCR technology to extract text and relevant information from scanned name cards. This technology enables automatic data entry and ensures accurate digitization of the name card details.

**Image Processing**

Image processing techniques are employed to enhance the scanned name card images, improve readability, and optimize the visual quality of the digitized cards. This helps in creating clear and professional-looking digital name cards.

**Mobile Camera Integration**

ConnectCard seamlessly integrates with the mobile device's camera functionality, allowing users to capture images of physical name cards directly within the app. This integration simplifies the scanning process, making it convenient for users to convert physical cards into digital format effortlessly.

**Near Field Communication (NFC)**

ConnectCard leverages on NFC technology for the seamless exchange of digital name cards between users. By tapping their devices together, users can instantly share their contact information, fostering efficient networking and eliminating the need for manual contact input.

**Cloud Storage and Synchronization (Firebase)**

To ensure data accessibility across multiple devices, our application integrates with cloud storage services. The digital name cards and associated data are securely stored in the cloud, enabling users to access and manage their cards from any device with the application installed. Synchronization functionality ensures that any updates made to the cards are reflected across all devices.

**Sharing digital name cards through a link**

ConnectCard encodes your digital name card, including contact details, such as name, phone number, email address, or social media profiles, into a link. This encoding process can be achieved with APIs available in various programming languages.

## System Design
**Application Flow**

![Application Flow Diagram](https://github.com/glenn2030/ConnectCard/blob/main/assets/System%20Design.png)

**Authentication**

When the ConnectCard app is opened, it checks for persistent login information. If the user is already logged in, they are directed to the Home Page. Otherwise, they are brought to the Login Page to authenticate their credentials.

On the Login Page, users have the option to toggle between the Login and Register pages. After inputting the correct email and password values, the app authenticates these values with Firebase. If the email and password are correct, the user is directed to the Home Page. If the authentication fails, the user is given the opportunity to try again.

**Profile Editing + Displaying**

In the Home Page, users can view their existing cards in either a list or card view. The cards display basic information such as the name, organization, position, phone number, and email address.

Users have the ability to edit their card information, including changing their name, in the Edit Card section. They can also choose to delete a card if they no longer need it.

Users can add a profile picture (DP) and update their card information in the Edit Page. These changes will be reflected both on the Home Page and in the database.

**OCR Image to Text converter**

The Scan Cards Page requires permission from the user to use the camera. Once permission is granted, users can take a photo of a name card. The app utilizes Google ML Kit and text recognition technology to convert the image into text, extracting relevant information from the name card.

**Navigation Bar**

The app features a navigation bar that allows users to easily navigate between different sections, including the Scan Cards Page, Friends Page, and Rewards Card Page. This provides a seamless user experience and quick access to different functionalities.

**Profile Bar**

Users can access the Profile Bar by clicking on their name. From there, they have several options. They can contact the app's support team, which will direct them to the email page. They can also go to the Settings Page to customize their app preferences. Additionally, users have the option to log out from the Profile Bar.

**Class Relationship**

![Class Relationship](https://github.com/glenn2030/ConnectCard/blob/main/assets/Objects%20Diagram.png)

## Features

### Login Page
![Login Page](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_LogIn.png)

Allows users to log in to their ConnectCard account using their email and password.
Provides a toggle option to switch to the Registration page for new users.

### Registration Page
![Registration Page](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_Register.png)

Allows new users to create a ConnectCard account by providing their email and password.
Validates the user's email and password to ensure they meet the necessary requirements.

### Home Page
![Home Page](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_HomePage.png)

Displays a list or card view of the user's stored name cards, showing basic information such as name, organization, position, phone number, and email address for each card.
Includes a navigation bar to access other pages.
Provides a profile bar to access the user's profile page.

### Card Editor Form Page
![Card Edit Form](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_CardsEditForm.png)

Allows users to edit their name and add, select, and edit name cards.
Validates the entered information and displays error messages if required fields are not filled.

### Card Editor Page
![Card Editor](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_CardEditor.png)

Loads the selected name card information from the database.
Allows users to add a display picture and update various information fields.
Provides an option to delete name cards, with a snack box appearing when attempting to delete the last card.

### Text Recog Page
![Text Recog Page](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_TextRecogCam.jpg)

Requests permission to use the camera for name card scanning.
Enables users to capture a photo of a name card.
Utilizes Google ML Kit and text recognition technology to convert the image into text and extract relevant information.

### Text Recog Result Page
![Text Recog Page](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_TextRecogResults.jpg)

Displays the results of the text conversion and extraction process.

### Profile Page
![Profile Page](https://github.com/glenn2030/ConnectCard/blob/main/assets/CC_ProfilePage.png)

Allows users to select options such as contacting customer support, accessing settings, or logging out.

## Project Log

Link: https://docs.google.com/spreadsheets/d/1aPRcCrV2DgaXbIsEnaVfjLGABb_CIqXqBk_hmSb5DgI/edit?usp=sharing

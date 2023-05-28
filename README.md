# ConnectCard

ConnectCard is a mobile application that allows users to scan, store, and manage their name cards digitally. Designed for recruiters, professionals, job seekers, and everyone else. Simplify networking, all in one place.

## Description

ConnectCard utilizes Firebase for data storage and manipulation, and Flutter for the user interface design. It offers various features such as scanning and storing name card information, linking the app to communication platforms like Telegram, Whatsapp, Phone, and Email, updating existing data, NFC technology for easy name card exchange, and a membership/reward card feature.

### Problem:

Carrying physical name cards and membership/loyalty cards can be burdensome, leading to lost contact information and a cluttered wallet. It is inconvenient for individuals who meet new people, engage in business interactions, or collect various membership cards to manage and access these cards efficiently.

### Need:

Currently, there are existing name cards applications that provide features such as storing and managing digital name cards of self and others. However, there are some few applications that satisfy some features that are important in a digital name card application.

Existing name card applications have limited functionality in these areas
Converting current physical name cards into digital name cards easily
Sharing digital name cards with others easily
Store and access membership or loyalty reward cards digitally, eliminating the reliance on physical cards.

### Solution:

ConnectCard provides a convenient solution by allowing users to scan physical name cards using their phone camera and convert them into digital cards stored within the application. Users can easily update their personal digital name cards, keeping their contact information up to date for seamless interactions. The application also enables users to exchange digital name cards effortlessly, through sending it through a link and using NFC technology. Furthermore, users can store and track their membership or loyalty reward cards digitally, while vendors can update customers' progress in real-time. With our app, individuals can simplify their wallet, stay connected with ease, and take full advantage of membership benefits without the hassle of physical cards.

## Table of Contents

- [Features](#features)
- [About](#Video+Poster)
- [ProjectLog](#projectlog)
- [License](#license)


## Features

### The following functionality is complete:
**Phase 1**

1. [x] **UI/UX of Application:** Finalized the design using FIGMA to be used as a template to guide

2. [x] **Login / Registration:** By using an email & password to login

### The following functionality is incomplete:

**Phase 2**
1. [] **Database:** The app uses Firebase as the backend database to store and manipulate data, ensuring efficient data management and retrieval. 

2. [] **Updating existing Data:** Users have the flexibility to update their personal digital name cards at any time. This feature is especially useful when users experience changes in their job positions or roles within their existing company.

3. [] **Communication Integration:** The app seamlessly integrates with popular communication platforms such as Telegram, Whatsapp, Phone, and Email. This enables users to easily connect with their clients directly from the app.

**Phase 3**
1. [] **Scanning and Storing Feature:** Users can use their device's camera to scan name cards and extract relevant information. The extracted information is then stored in the Firebase database, allowing easy access and reference.

2. [] **NFC Technology for Name Card Exchange:** The app leverages NFC technology to facilitate the exchange of digital name cards between users. By simply tapping their phones together, users can transfer their digital name cards conveniently.

3. [] **Membership/Reward Card Feature:** Users can convert their physical membership or milestone reward cards into digital versions. Vendors can access and update users' progress using the app, providing a seamless and centralized way to manage loyalty programs.

## Poster & Video

To watch the video of ConnectCard & view the poster, click the following link

Video: https://drive.google.com/file/d/1KqCCN2fL1QiHnOnuNatBzYJn6tmiY9W4/view?usp=share_link

Poster: https://drive.google.com/file/d/1Xfcv88yRIS-P9JojkY_17qMARUUyWp3c/view?usp=share_link

Figma Deisgn: https://www.figma.com/file/hVvHnTKv5smJBOPmTPnpZP/Connect-Card?type=design&node-id=0%3A1&t=8YLkiicqGAFXCIrQ-1

### Key Technologies

**Optical Character Recognition (OCR)**:
ConnectCard utilizes OCR technology to extract text and relevant information from scanned name cards. This technology enables automatic data entry and ensures accurate digitization of the name card details.

**Image Processing**:
Image processing techniques are employed to enhance the scanned name card images, improve readability, and optimize the visual quality of the digitized cards. This helps in creating clear and professional-looking digital name cards.

**Mobile Camera Integration**:
ConnectCard seamlessly integrates with the mobile device's camera functionality, allowing users to capture images of physical name cards directly within the app. This integration simplifies the scanning process, making it convenient for users to convert physical cards into digital format effortlessly.

**Near Field Communication (NFC)**:
ConnectCard leverages on NFC technology for the seamless exchange of digital name cards between users. By tapping their devices together, users can instantly share their contact information, fostering efficient networking and eliminating the need for manual contact input.

**Cloud Storage and Synchronization (Firebase)**:
To ensure data accessibility across multiple devices, our application integrates with cloud storage services. The digital name cards and associated data are securely stored in the cloud, enabling users to access and manage their cards from any device with the application installed. Synchronization functionality ensures that any updates made to the cards are reflected across all devices.

**Sharing digital name cards through a link**:
ConnectCard encodes your digital name card, including contact details, such as name, phone number, email address, or social media profiles, into a link. This encoding process can be achieved with APIs available in various programming languages.

## Project Log

### May
**[2023-05-09]** : 4 Hours @ Zhiwei House
- A4 Poster (LiftOff)
- Video (LiftOff)

**[2023-05-10]** : 4 Hours @ Zhiwei House
- Finalized user interface design using Figma.

**[2023-05-11 - 2023-05-13]** : 10 Hours
- Flutter tutorial

**[2023-05-16]** : 2 Hours
- GIT Crash Course
- Created the repository

**[2023-05-18 - 2023-05-22]** : 10 Hours
- Flutter tutorial
- Firebase integration tutorial

**[2023-05-24 - 2023-05-25]** : 5 Hours @ Zhiwei House
- initialized Firebase for database management.
- Registration Screen
- Login Screen

**[2023-05-27 - 2023-05-28]** : 8 Hours
- Loading Screen
- Setting up profile data, linking to firebase
- Editing profile data
- adding more cards
- Splash Screen Update

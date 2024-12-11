# Smart Parking App 🚗📱

## 🚀 Functions

### 1. **User Authorization**
- Login
- Login with Google
- Sign-Up
- Logout
- Forgot Password

### 2. **Profile Management**
- Setup Profile
- Edit Profile

### 3. **Real-Time Parking Space Availability**

### 4. **Parking Space Reservation**

### 5. **Payment Integration**
- Payment with debit/credit card
- Payment with PayPal
- Payment with cryptocurrency

### 6. **GPS Navigation to Parking Spot**

### 7. **Push Notifications**

### 8. **Parking History and Receipts**

### 9. **Feedback Sharing**

---

## 💳 **Payment Integration**

### **1. Payment with Debit/Credit Card (via Stripe)**

The app integrates **Stripe** for secure and seamless card payments:
- **Stripe Setup**: The user can securely pay for parking using their debit or credit card.
- **Stripe API**: The app communicates with the Stripe API to handle payment transactions.
- **PCI Compliance**: The app ensures that sensitive card details are handled according to the highest security standards, ensuring PCI DSS compliance.

  **Integration steps:**
   - Install the Stripe Flutter package:  
     `flutter pub add stripe_payment`
   - Set up **Stripe** in the app using your **API keys** from the Stripe dashboard.
   - Handle the payment process using the Stripe SDK, allowing users to securely input card information and complete transactions.

---

### **2. Payment with Cryptocurrency (via NOWPayments)**

For users who prefer to pay with cryptocurrency, the app integrates **NOWPayments**, a payment gateway supporting over 100 cryptocurrencies:
- **NOWPayments Setup**: Users can choose to pay with Bitcoin, Ethereum, or other supported cryptocurrencies.
- **Integration with NOWPayments API**: The app connects to NOWPayments to process payments securely.
- **Transaction Monitoring**: The app can monitor the transaction status to ensure the payment is successfully completed before confirming the parking reservation.

  **Integration steps:**
   - Register on **NOWPayments** and get your API key.
   - Add the **NOWPayments** Flutter package:  
     `flutter pub add nowpayments`
   - Configure the API calls in your app to generate an invoice and process cryptocurrency payments.
   - Handle payment status updates and confirmations via webhooks or polling.

---

## 🗂️ Firebase Integration

The app uses **Firebase** to power its backend services:
- **Authentication**: For secure user login and sign-up.
- **Firestore**: To store and retrieve real-time parking and user data.
- **Firebase Messaging**: To send push notifications.

---

## 📖 How to Run

1. Clone the repository:  
   `git clone https://github.com/Pchelalala/smart-parking-app.git`  
   `cd smart-parking-app`

2. Install dependencies:  
   `flutter pub get`

3. Set up Firebase:
    - Add `google-services.json` to the `android/app` directory.
    - Add `GoogleService-Info.plist` to the `ios/Runner` directory.

4. Run the app:  
   `flutter run`

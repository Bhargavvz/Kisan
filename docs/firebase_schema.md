# Project Kisan Firestore Database Schema

## users
Collection of user profiles and settings.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | string | Unique user ID (matches Firebase Auth UID) |
| name | string | User's full name |
| phoneNumber | string | User's phone number with country code |
| email | string | User's email (optional) |
| address | string | User's physical address |
| language | string | Preferred language code (e.g., 'en', 'kn') |
| profileImageUrl | string | URL to user's profile image |
| isGuest | boolean | Whether this is a guest user |
| createdAt | timestamp | When the user account was created |
| lastLoginAt | timestamp | When the user last logged in |
| preferences | map | User preferences |
| preferences.language | string | Preferred language code |
| preferences.theme | string | Theme preference ('light', 'dark', 'system') |
| preferences.notifications | boolean | Whether notifications are enabled |
| preferences.locationAccess | boolean | Whether location access is granted |

## crop_diagnoses
Collection of crop disease diagnoses.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | string | Unique diagnosis ID |
| userId | string | ID of the user who submitted the diagnosis |
| cropType | string | Type of crop (e.g., 'Tomato', 'Rice') |
| description | string | User description of the issue |
| imageUrl | string | URL to the uploaded crop image |
| location | string | Where the crop was grown |
| status | string | Status of diagnosis ('pending', 'processing', 'completed', 'failed', 'healthy') |
| submittedAt | timestamp | When the diagnosis was submitted |
| completedAt | timestamp | When the diagnosis was completed |
| diagnosisResult | map | Diagnosis result (if completed) |
| diagnosisResult.disease | string | Identified disease name |
| diagnosisResult.confidence | number | Confidence level (0.0-1.0) |
| diagnosisResult.description | string | Disease description |
| diagnosisResult.treatment | array | List of treatment recommendations |
| diagnosisResult.prevention | array | List of prevention measures |
| diagnosisResult.severity | string | Disease severity ('low', 'moderate', 'high', 'critical') |

## crop_prices
Collection of market prices for crops.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | string | Unique price entry ID |
| cropName | string | Name of the crop |
| cropNameLower | string | Lowercase version for search |
| category | string | Category ('Vegetables', 'Fruits', 'Grains', etc.) |
| currentPrice | number | Current price per unit |
| previousPrice | number | Previous price (for tracking changes) |
| unit | string | Unit of measurement (e.g., 'kg', 'dozen') |
| marketName | string | Name of the market |
| location | string | Geographic location of the market |
| lastUpdated | timestamp | When the price was last updated |
| imageUrl | string | URL to crop image |
| description | string | Additional information |

## subsidies
Collection of government subsidy schemes.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | string | Unique subsidy scheme ID |
| schemeName | string | Name of the subsidy scheme |
| description | string | Description of the scheme |
| category | string | Category ('Income Support', 'Irrigation', etc.) |
| maxAmount | number | Maximum amount available |
| eligibilityCriteria | array | List of eligibility criteria |
| requiredDocuments | array | List of required documents |
| applicationProcess | string | Process to apply for the subsidy |
| deadline | timestamp | Application deadline |
| department | string | Government department responsible |
| contactNumber | string | Contact number for inquiries |
| website | string | Official website for the scheme |
| isActive | boolean | Whether the scheme is currently active |

## subsidy_applications
Collection of user applications for subsidies.

| Field | Type | Description |
| ----- | ---- | ----------- |
| id | string | Unique application ID |
| userId | string | ID of the user who submitted the application |
| subsidyId | string | ID of the subsidy scheme |
| applicationData | map | Application form data |
| status | string | Status ('pending', 'approved', 'rejected', 'under_review') |
| submittedAt | timestamp | When the application was submitted |
| updatedAt | timestamp | When the application was last updated |
| documents | array | List of uploaded document URLs |
| remarks | string | Additional remarks or notes |

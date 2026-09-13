# 🎛️ StriveWheels Admin Panel

**StriveWheels Admin Panel** is a modern, high-performance web dashboard built with **Next.js (App Router)**, **TypeScript**, and **Tailwind CSS**. It empowers administrators and operations teams to monitor live rides, review driver KYC registrations, manage fare configurations, issue coupons, oversee corporate accounts, and maintain system analytics in real-time.

---

## 📌 Features & Functional Modules

| Module | Features & Capabilities |
| :--- | :--- |
| **🔐 Auth & Access Control** | Secure JWT-based admin authentication, role-based permissions (`ADMIN`, `SUPER_ADMIN`). |
| **📊 Executive Dashboard** | Real-time platform metrics: active rides, total earnings, active drivers, completed trips, and platform commission analytics. |
| **🪪 Driver Onboarding & KYC** | Full inspection of driver applications, vehicle documents (RC, Insurance, Permit), identity verification (Aadhaar, DL), document approval/rejection, and driver activation. |
| **🚕 Fleet & Vehicle Types** | Management of supported vehicle categories (Cab, Auto, Bike, Tempo, Mini Bus), capacity limits, and status toggles. |
| **💰 Fare & Rate Card Config** | Granular pricing management: Base fare, per-KM rate, per-minute rate, surge multipliers, AC/Non-AC rates, and real-time weather/traffic fare multipliers. |
| **🎟️ Coupons & Discounts** | Creation, tracking, and management of promotional discount codes (flat amount or percentage-based) with validity windows and usage limits. |
| **🚖 Booking Operations** | Search, filter, and view detailed trip histories, monitor live ride states, force-cancel trips with custom reasons, and audit deleted bookings. |
| **🏢 Corporate Management** | Manage corporate partner accounts, maintain employee rosters, and allocate monthly travel budgets or usage permissions. |

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Next.js 14+ (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS + Shadcn UI / Radix Primitives
- **State Management**: React Query / TanStack Query & Zustand
- **HTTP Client**: Axios with JWT Interceptors & Auto-refresh logic
- **Icons & Visuals**: Lucide React / Recharts (for Analytics charts)

---

## 🚀 Getting Started

### Prerequisites

- **Node.js**: `v18.x` or higher
- **npm** / **yarn** / **pnpm**

### Installation

```bash
# Navigate to the admin directory
cd admin

# Install dependencies
npm install
# or
pnpm install
```

### Environment Configuration

Create a `.env.local` file in the `admin` root directory:

```env
NEXT_PUBLIC_API_BASE_URL=http://localhost:8000/api/v1
NEXT_PUBLIC_WEBSOCKET_URL=ws://localhost:8000/ws
```

### Running Development Server

```bash
npm run dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to view the Admin Dashboard.

---

## 🔌 API Integration Reference

All admin API endpoints interact with the StriveWheels FastAPI backend (`/api/v1`). All protected routes require a Bearer token: `Authorization: Bearer <JWT_ACCESS_TOKEN>`.

### 1. Unified Response Wrapper Format

All backend responses adhere to standard `ApiResponse<T>` JSON wrappers:

#### Success Response Example (`200 OK`):
```json
{
  "success": true,
  "message": "Data retrieved successfully.",
  "data": {},
  "error": null,
  "meta": null
}
```

#### Error Response Example (`400 Bad Request` / `401 Unauthorized` / `404 Not Found`):
```json
{
  "success": false,
  "message": "Invalid credentials or unauthorized access",
  "data": null,
  "error": {
    "code": "UNAUTHORIZED",
    "details": null
  },
  "meta": null
}
```

---

### 2. Core API Endpoints

#### 🔐 Authentication & Session
- **POST** `/auth/admin/login`
  - **Payload**:
    ```json
    {
      "email_or_phone": "admin@strivewheels.com",
      "password": "SecureAdminPassword123!"
    }
    ```
  - **Response**: Returns `access_token`, `refresh_token`, `token_type`, and user role info.

- **POST** `/auth/refresh`
  - **Payload**: `{ "refresh_token": "<REFRESH_TOKEN>" }`

---

#### 📊 Dashboard & System Analytics
- **GET** `/admin/dashboard/stats`
  - **Response Data**:
    ```json
    {
      "total_users": 1250,
      "total_riders": 340,
      "active_bookings": 18,
      "completed_bookings": 4890,
      "total_revenue": 154200.50,
      "pending_driver_verifications": 12
    }
    ```

---

#### 🪪 Driver Registration & KYC Review
- **GET** `/admin/driver-registrations`
  - Query params: `status` (`PENDING`, `APPROVED`, `REJECTED`), `limit`, `offset`.
  - **Response**: List of submitted driver registration applications.

- **GET** `/admin/driver-registrations/{id}`
  - **Response**: Detailed master registration info including personal info, driving license details, bank account, and uploaded document URLs.

- **POST** `/admin/driver-registrations/{id}/verify-document`
  - **Payload**:
    ```json
    {
      "document_type": "DL",
      "is_verified": true,
      "rejection_reason": null
    }
    ```

- **POST** `/admin/driver-registrations/{id}/review`
  - **Payload**:
    ```json
    {
      "status": "APPROVED",
      "remarks": "All documents verified successfully."
    }
    ```

---

#### 💰 Fare Configurations & Multipliers
- **GET** `/admin/fare-configs`
  - **Response**: Array of fare configs per vehicle type.

- **POST** `/admin/fare-configs`
  - **Payload**:
    ```json
    {
      "vehicle_type_id": 1,
      "base_fare": 60.0,
      "min_fare": 100.0,
      "per_km_rate": 18.0,
      "per_min_rate": 2.5,
      "waiting_per_min_rate": 2.0,
      "cancellation_fee": 50.0,
      "night_charge_multiplier": 1.2,
      "surge_multiplier": 1.0,
      "platform_commission_pct": 15.0
    }
    ```

- **POST** `/admin/fare-multipliers/weather`
  - **Payload**: `{ "weather_condition": "HEAVY_RAIN", "multiplier": 1.35 }`

- **POST** `/admin/fare-multipliers/traffic`
  - **Payload**: `{ "traffic_level": "VERY_HIGH", "multiplier": 1.25 }`

---

#### 🎟️ Coupon & Promo Management
- **GET** `/admin/coupons`
- **POST** `/admin/coupons`
  - **Payload**:
    ```json
    {
      "code": "STRIVE20",
      "discount_type": "PERCENTAGE",
      "discount_value": 20.0,
      "max_discount_amount": 100.0,
      "min_booking_amount": 250.0,
      "valid_from": "2026-09-01T00:00:00Z",
      "valid_until": "2026-10-01T00:00:00Z",
      "usage_limit": 500,
      "is_active": true
    }
    ```

---

#### 🚖 Booking Control & Management
- **GET** `/admin/bookings`
  - Query params: `status`, `user_id`, `rider_id`, `limit`, `offset`.

- **POST** `/admin/bookings/{id}/cancel`
  - **Payload**: `{ "reason": "System administrative override" }`

- **DELETE** `/admin/bookings/{id}`
  - Deletes or archives booking record from the administrative database.

---

#### 🏢 Corporate Account Management
- **POST** `/companies`
  - Creates a corporate account.
- **GET** `/companies/{id}/employees`
- **POST** `/companies/{id}/employees`
  - **Payload**:
    ```json
    {
      "employee_name": "Jane Doe",
      "email": "jane@corporate.com",
      "phone": "+919876543210",
      "monthly_allowance": 5000.0
    }
    ```

---

## 📁 Project Folder Structure

```
admin/
├── app/                      # Next.js App Router directory
│   ├── (auth)/               # Admin Login & Auth pages
│   ├── (dashboard)/          # Authenticated Admin Dashboard routes
│   │   ├── page.tsx          # Main Overview Dashboard
│   │   ├── drivers/          # Driver KYC Verification & Approvals
│   │   ├── fare-rates/       # Fare Configs & Multipliers
│   │   ├── bookings/         # Ride Operations & Live Monitoring
│   │   ├── coupons/          # Coupon & Promo Code Management
│   │   ├── corporate/        # Corporate Accounts & Employees
│   │   └── settings/         # System Settings
│   ├── api/                  # Next.js API Routes (if needed)
│   ├── layout.tsx            # Root Layout with Theme & Context Providers
│   └── globals.css           # Global Styles & Tailwind Config
├── components/               # Reusable UI Components
│   ├── ui/                   # Buttons, Cards, Inputs, Dialogs (Shadcn UI)
│   ├── dashboard/            # Charts, Stat Cards, Activity Tables
│   └── layout/               # Sidebar, Header, User Menu
├── lib/                      # Core Utilities & Configurations
│   ├── api-client.ts         # Axios instance with Interceptors
│   ├── constants.ts          # App Constants & API Endpoints
│   └── utils.ts              # Helper functions & Classname mergers
├── types/                    # TypeScript interfaces and backend schema definitions
├── .env.local                # Local Environment Variables
├── next.config.mjs           # Next.js configuration
├── package.json              # Project Dependencies
└── README.md                 # Admin Panel Documentation
```

---

## 🤝 Contribution & Maintenance Rules

- Maintain strict TypeScript type safety (`noImplicitAny`).
- All REST API calls must be wrapped in `try/catch` or React Query error boundaries handling standard `ApiResponse` format.
- Secure sensitive tokens using `HttpOnly` cookies or local storage with automated refresh handling on `401 Unauthorized`.

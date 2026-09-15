# StriveWheels: Admin / Super Admin Role

## Overview
The `ADMIN` (or `SUPER_ADMIN`) role has the highest level of clearance within the StriveWheels platform. This role is responsible for complete operational oversight, system configuration, and managing the overall health and economics of the ride-sharing platform.

## Key Responsibilities & Access

### 1. Operations & Monitoring
- **Dashboard (`/admin`)**: High-level metrics tracking total users, trips, revenue, and active drivers.
- **Bookings (`/admin/bookings`)**: Full visibility into all ride bookings across the platform. Ability to monitor trip statuses in real-time.

### 2. User & Fleet Management
- **Users (`/admin/users`)**: Manage all platform users (customers, drivers, etc.).
- **Driver Verifications (`/admin/driver-registrations`)**: Review and approve/reject driver KYC submissions (Aadhaar, Driving License, Background Checks).

### 3. Economics & Configuration
- **Vehicle Types (`/admin/vehicle-types`)**: Manage vehicle categories (Cabs, Autos, Bikes) and their base capabilities.
- **Fare Configs (`/admin/fare-configs`)**: Define base fares, per-KM rates, and platform fees.
- **Traffic Fares (`/admin/traffic-fares`)**: Manage dynamic surge pricing multipliers based on local traffic conditions.
- **Weather Fares (`/admin/weather-fares`)**: Manage dynamic surge pricing multipliers triggered by weather (e.g., rain surge).
- **Coupons (`/admin/coupons`)**: Create, distribute, and manage promotional discount codes to drive user acquisition and retention.

### 4. Advanced Services
- **Quick Services (`/admin/quick-services`)**: Manage specialized or rapid-access service offerings.
- **Popular Locations (`/admin/popular-locations`)**: Define geofenced hotspots to guide driver supply and manage demand.

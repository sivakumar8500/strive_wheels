import { PopularLocation } from "../types";

export const MOCK_POPULAR_LOCATIONS: PopularLocation[] = [
  {
    id: 1,
    name: "Central Railway Station",
    address: "Station Rd, City Center",
    latitude: 12.971598,
    longitude: 77.594562,
    category: "TRANSIT",
    is_active: true,
  },
  {
    id: 2,
    name: "International Airport",
    address: "Airport Road",
    latitude: 13.1986,
    longitude: 77.7066,
    category: "TRANSIT",
    is_active: true,
  },
  {
    id: 3,
    name: "Cyber Park IT Zone",
    address: "Ring Road, Phase 1",
    latitude: 12.9229,
    longitude: 77.6322,
    category: "OFFICE",
    is_active: true,
  },
  {
    id: 4,
    name: "City Mall",
    address: "High Street",
    latitude: 12.9351,
    longitude: 77.6244,
    category: "LEISURE",
    is_active: false,
  },
];

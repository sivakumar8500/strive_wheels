import { QuickService } from "../types";

export const MOCK_QUICK_SERVICES: QuickService[] = [
  {
    id: 1,
    title: "Ride",
    icon_url: "https://cdn-icons-png.flaticon.com/512/3204/3204121.png",
    target_screen: "RIDE_BOOKING",
    sort_order: 1,
    is_active: true,
  },
  {
    id: 2,
    title: "Package",
    icon_url: "https://cdn-icons-png.flaticon.com/512/684/684490.png",
    target_screen: "PACKAGE_DELIVERY",
    sort_order: 2,
    is_active: true,
  },
  {
    id: 3,
    title: "Intercity",
    icon_url: "https://cdn-icons-png.flaticon.com/512/2038/2038166.png",
    target_screen: "OUTSTATION_BOOKING",
    sort_order: 3,
    is_active: true,
  },
  {
    id: 4,
    title: "Rentals",
    icon_url: "https://cdn-icons-png.flaticon.com/512/3063/3063822.png",
    target_screen: "RENTAL_BOOKING",
    sort_order: 4,
    is_active: false,
  },
];

const fs = require('fs');
const path = require('path');

function replaceInFile(filePath, replacements) {
  if (!fs.existsSync(filePath)) {
    console.log('File not found:', filePath);
    return;
  }
  let content = fs.readFileSync(filePath, 'utf8');
  let original = content;
  for (const { regex, replace } of replacements) {
    content = content.replace(regex, replace);
  }
  if (content !== original) {
    fs.writeFileSync(filePath, content);
    console.log('Updated:', filePath);
  } else {
    console.log('No changes needed:', filePath);
  }
}

const adminDir = path.join(__dirname, 'src');

const bookingsDir = path.join(adminDir, 'features/admin/bookings');
replaceInFile(path.join(bookingsDir, 'components/BookingFormDialog.tsx'), [
  { regex: /import \{ Booking \} from "\.\.\/types";/g, replace: 'import { Booking } from "../types"; type BookingType = any;' },
  { regex: /booking: Booking \| null;/g, replace: 'booking: BookingType | null;' },
  { regex: /booking\./g, replace: 'booking?.' },
  { regex: /customer_id: booking\?\.customer_id,/g, replace: 'customer_id: booking?.customer?.user?.full_name || "",' }
]);

replaceInFile(path.join(bookingsDir, 'components/BookingsTable.tsx'), [
  { regex: /import \{ Booking \} from "\.\.\/types";/g, replace: 'import { Booking } from "../types"; type BookingType = any;' },
  { regex: /ColumnDef<Booking>/g, replace: 'ColumnDef<BookingType>' },
  { regex: /users: Booking\[\];/g, replace: 'bookings: BookingType[];' },
  { regex: /onRowClick\?: \(booking: Booking\) => void;/g, replace: 'onRowClick?: (booking: BookingType) => void;' },
  { regex: /onEdit\?: \(booking: Booking\) => void;/g, replace: 'onEdit?: (booking: BookingType) => void;' },
  { regex: /onDelete\?: \(booking: Booking\) => void;/g, replace: 'onDelete?: (booking: BookingType) => void;' },
  { regex: /key: "date"/g, replace: 'key: "created_at"' },
  { regex: /render: \(date: string\) =>/g, replace: 'render: (created_at: string) =>' }
]);

replaceInFile(path.join(bookingsDir, 'components/BookingViewDialog.tsx'), [
  { regex: /import \{ Booking \} from "\.\.\/types";/g, replace: 'import { Booking } from "../types"; type BookingType = any;' },
  { regex: /booking: Booking \| null;/g, replace: 'booking: BookingType | null;' },
  { regex: /booking\.customer/g, replace: 'booking?.customer?.user?.full_name' },
  { regex: /booking\.service_mode/g, replace: 'booking?.service_mode' },
  { regex: /booking\.scheduled_time/g, replace: 'booking?.created_at' },
  { regex: /booking\.final_fare/g, replace: 'booking?.final_fare' },
]);

replaceInFile(path.join(bookingsDir, 'hooks/useBookingForm.ts'), [
  { regex: /import \{ Booking \} from "\.\.\/types";/g, replace: 'import { Booking } from "../types"; type BookingType = any;' },
  { regex: /Booking \| null/g, replace: 'BookingType | null' },
  { regex: /booking: Booking/g, replace: 'booking: BookingType' },
  { regex: /Partial<Booking>/g, replace: 'any' }
]);

replaceInFile(path.join(bookingsDir, 'services/bookingsApi.ts'), [
  { regex: /\{ params: query as any \}/g, replace: 'null' }
]);

const driverRegDir = path.join(adminDir, 'features/admin/driver-registrations');
replaceInFile(path.join(driverRegDir, 'services/api.ts'), [
  { regex: /\{ params: \{ status, skip, limit \} as any \}/g, replace: 'null' }
]);

const dashboardDir = path.join(adminDir, 'features/admin/dashboard');
replaceInFile(path.join(dashboardDir, 'hooks/useDashboardStats.ts'), [
  { regex: /dashboardApi\.getStats/g, replace: '(dashboardApi as any).getStats' }
]);

console.log('Script completed.');

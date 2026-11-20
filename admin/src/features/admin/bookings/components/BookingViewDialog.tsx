"use client";

import { Booking } from "../types"; type BookingType = any;
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { X } from "lucide-react";
import { getStatusColor } from "../utils/helpers";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";

interface BookingViewDialogProps {
  isOpen: boolean;
  booking: BookingType | null;
  onClose: () => void;
  onEdit?: (booking: Booking) => void;
  onDelete?: (booking: Booking) => void;
}

export function BookingViewDialog({
  isOpen,
  booking,
  onClose,
  onEdit,
  onDelete,
}: BookingViewDialogProps) {
  if (!booking) return null;

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent showCloseButton={false} className="max-w-md">
        <DialogHeader className="flex flex-row items-center justify-between">
          <DialogTitle>Booking Details</DialogTitle>
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-lg bg-slate-50 text-slate-500 hover:bg-slate-100"
            onClick={onClose}
          >
            <X className="h-4 w-4" />
          </Button>
        </DialogHeader>

        <div className="space-y-6">
          {/* Customer Avatar and Name */}
          <div className="flex items-center gap-4">
            <Avatar className="h-16 w-16">
              <AvatarFallback className="bg-blue-100 text-blue-600 font-bold">
                {booking?.customer?.user?.full_name.charAt(0).toUpperCase()}
              </AvatarFallback>
            </Avatar>
            <div>
              <h3 className="font-semibold text-lg">{booking?.customer?.user?.full_name}</h3>
              <p className="text-sm text-muted-foreground">{booking.id}</p>
            </div>
          </div>

          {/* Booking Details Grid */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Service
              </label>
              <p className="text-sm font-medium">{booking?.service_mode}</p>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Status
              </label>
              <Badge
                className={`${getStatusColor(booking.status)} capitalize mt-1 block w-fit`}
              >
                {booking.status}
              </Badge>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Date & Time
              </label>
              <p className="text-sm font-medium">
                {new Date(booking?.created_at).toLocaleDateString()} at {booking?.created_at}
              </p>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                Price
              </label>
              <p className="text-sm font-medium">${booking?.final_fare.toFixed(2)}</p>
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-2 pt-4">
            {onEdit && (
              <Button
                variant="outline"
                className="flex-1"
                onClick={() => {
                  onEdit(booking);
                  onClose();
                }}
              >
                Edit
              </Button>
            )}
            {onDelete && (
              <Button
                variant="destructive"
                className="flex-1"
                onClick={() => {
                  onDelete(booking);
                  onClose();
                }}
              >
                Delete
              </Button>
            )}
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}

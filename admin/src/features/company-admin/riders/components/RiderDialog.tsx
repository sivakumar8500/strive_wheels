import { useState, useEffect } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { CompanyRider, AssignRiderRequest } from "../types";
import { useAssignCompanyRider, useUpdateCompanyRider } from "../hooks/use-riders";

interface RiderDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  rider?: CompanyRider | null;
}

export function RiderDialog({ open, onOpenChange, rider }: RiderDialogProps) {
  const isEditing = !!rider;
  
  const [formData, setFormData] = useState<AssignRiderRequest>({
    driver_name: "",
    phone: "",
    route_assigned: "",
    start_date: new Date().toISOString().split("T")[0],
    end_date: "",
    status: "ACTIVE",
  });

  const { mutate: assignRider, isPending: isAssigning } = useAssignCompanyRider();
  const { mutate: updateRider, isPending: isUpdating } = useUpdateCompanyRider();

  useEffect(() => {
    if (open) {
      if (rider) {
        setFormData({
          driver_name: rider.driver_name,
          phone: rider.phone,
          route_assigned: rider.route_assigned,
          start_date: rider.start_date,
          end_date: rider.end_date,
          status: rider.status,
        });
      } else {
        setFormData({
          driver_name: "",
          phone: "",
          route_assigned: "",
          start_date: new Date().toISOString().split("T")[0],
          end_date: "",
          status: "ACTIVE",
        });
      }
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, rider?.id]); // Avoid object dependency to prevent lint warnings/cascading effects

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (isEditing && rider) {
      updateRider(
        { id: rider.id, data: formData },
        {
          onSuccess: () => {
            onOpenChange(false);
          },
        }
      );
    } else {
      assignRider(formData, {
        onSuccess: () => {
          onOpenChange(false);
        },
      });
    }
  };

  const isPending = isAssigning || isUpdating;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>{isEditing ? "Edit Assignment" : "Assign Dedicated Rider"}</DialogTitle>
          <DialogDescription>
            {isEditing
              ? "Update the dedicated route contract details."
              : "Assign a new dedicated driver to a specific corporate route."}
          </DialogDescription>
        </DialogHeader>
        <form onSubmit={handleSubmit}>
          <div className="grid gap-4 py-4">
            
            <div className="grid gap-2">
              <Label htmlFor="driver_name">Driver Name <span className="text-red-500">*</span></Label>
              <Input
                id="driver_name"
                value={formData.driver_name}
                onChange={(e) => setFormData({ ...formData, driver_name: e.target.value })}
                placeholder="Rajesh Kumar"
                required
              />
            </div>

            <div className="grid gap-2">
              <Label htmlFor="phone">Phone Number <span className="text-red-500">*</span></Label>
              <Input
                id="phone"
                value={formData.phone}
                onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                placeholder="+919876543210"
                required
              />
            </div>

            <div className="grid gap-2">
              <Label htmlFor="route_assigned">Route Description <span className="text-red-500">*</span></Label>
              <Input
                id="route_assigned"
                value={formData.route_assigned}
                onChange={(e) => setFormData({ ...formData, route_assigned: e.target.value })}
                placeholder="e.g. Noida Sector 62 to Office"
                required
              />
            </div>
            
            <div className="grid grid-cols-2 gap-4">
              <div className="grid gap-2">
                <Label htmlFor="start_date">Contract Start</Label>
                <Input
                  id="start_date"
                  type="date"
                  value={formData.start_date}
                  onChange={(e) => setFormData({ ...formData, start_date: e.target.value })}
                  required
                />
              </div>
              <div className="grid gap-2">
                <Label htmlFor="end_date">Contract End</Label>
                <Input
                  id="end_date"
                  type="date"
                  value={formData.end_date}
                  onChange={(e) => setFormData({ ...formData, end_date: e.target.value })}
                  required
                />
              </div>
            </div>

            <div className="grid gap-2">
              <Label htmlFor="status">Status</Label>
              <Select
                value={formData.status}
                onValueChange={(value: "ACTIVE" | "EXPIRED" | "TERMINATED") => setFormData({ ...formData, status: value })}
              >
                <SelectTrigger id="status">
                  <SelectValue placeholder="Select status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="ACTIVE">Active</SelectItem>
                  <SelectItem value="EXPIRED">Expired</SelectItem>
                  <SelectItem value="TERMINATED">Terminated</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)} disabled={isPending}>
              Cancel
            </Button>
            <Button type="submit" disabled={isPending}>
              {isPending ? "Saving..." : isEditing ? "Save Changes" : "Assign Rider"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}

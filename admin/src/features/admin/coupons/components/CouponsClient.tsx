"use client";

import { useState } from "react";
import { format } from "date-fns";
import {
  useCoupons,
  useCreateCoupon,
  useUpdateCoupon,
  useDeleteCoupon,
} from "../hooks/use-coupons";
import PageHeaderwithAddButton from "@/components/shared/PageHeader";
import { CouponDialog } from "./CouponDialog";
import { Coupon, CreateCouponRequest, UpdateCouponRequest } from "../types";
import { Button } from "@/components/ui/button";
import { DataTable, type ColumnDef } from "@/components/common/Table/DataTable";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Loader2, Plus, MoreHorizontal, Pencil, Trash2, Tag, CalendarIcon } from "lucide-react";
import { Progress } from "@/components/ui/progress";

export function CouponsClient() {
  const { data: coupons, isLoading, isError, refetch } = useCoupons();
  const createMutation = useCreateCoupon();
  const updateMutation = useUpdateCoupon();
  const deleteMutation = useDeleteCoupon();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [selectedCoupon, setSelectedCoupon] = useState<Coupon | null>(null);

  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [couponToDelete, setCouponToDelete] = useState<number | null>(null);

  const handleOpenCreate = () => {
    setSelectedCoupon(null);
    setDialogOpen(true);
  };

  const handleOpenEdit = (coupon: Coupon) => {
    setSelectedCoupon(coupon);
    setDialogOpen(true);
  };

  const handleDialogSubmit = (values: CreateCouponRequest) => {
    if (selectedCoupon) {
      updateMutation.mutate(
        { id: selectedCoupon.id, data: values as UpdateCouponRequest },
        {
          onSuccess: () => setDialogOpen(false),
        }
      );
    } else {
      createMutation.mutate(values, {
        onSuccess: () => setDialogOpen(false),
      });
    }
  };

  const confirmDelete = (id: number) => {
    setCouponToDelete(id);
    setDeleteDialogOpen(true);
  };

  const handleDelete = () => {
    if (couponToDelete !== null) {
      deleteMutation.mutate(couponToDelete, {
        onSuccess: () => setDeleteDialogOpen(false),
      });
    }
  };

  const columns: ColumnDef<Coupon>[] = [
    {
      key: "code",
      label: "Code & Discount",
      render: (_, coupon) => (
        <div className="flex items-start gap-3">
          <div className="mt-1 h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
            <Tag className="h-4 w-4 text-primary" />
          </div>
          <div>
            <p className="font-bold text-lg uppercase tracking-wider">{coupon.code}</p>
            <p className="text-sm font-medium text-emerald-600">
              {coupon.discount_type === "PERCENTAGE" 
                ? `${coupon.discount_value}% OFF` 
                : `$${coupon.discount_value} FLAT`}
            </p>
          </div>
        </div>
      ),
    },
    {
      key: "max_discount_amount",
      label: "Constraints",
      render: (_, coupon) => (
        <div className="text-sm space-y-1 text-muted-foreground">
          <p>Max Disc: <span className="font-medium text-foreground">${coupon.max_discount_amount}</span></p>
          <p>Min Ride: <span className="font-medium text-foreground">${coupon.min_ride_amount}</span></p>
        </div>
      ),
    },
    {
      key: "start_date",
      label: "Validity Period",
      render: (_, coupon) => (
        <div className="text-sm space-y-1">
          <div className="flex items-center gap-2">
            <CalendarIcon className="h-3 w-3 text-muted-foreground" />
            <span>Start: {format(new Date(coupon.start_date), "MMM d, yyyy HH:mm")}</span>
          </div>
          <div className="flex items-center gap-2">
            <CalendarIcon className="h-3 w-3 text-muted-foreground" />
            <span>End: {format(new Date(coupon.end_date), "MMM d, yyyy HH:mm")}</span>
          </div>
        </div>
      ),
    },
    {
      key: "times_used",
      label: "Usage Stats",
      render: (_, coupon) => {
        const usagePercentage = (coupon.times_used / coupon.usage_limit) * 100;
        return (
          <div className="w-[120px] space-y-2">
            <div className="flex items-center justify-between text-xs">
              <span className="text-muted-foreground">Used</span>
              <span className="font-medium">{coupon.times_used} / {coupon.usage_limit}</span>
            </div>
            <Progress value={usagePercentage} className="h-2" />
          </div>
        );
      },
    },
    {
      key: "is_active",
      label: "Status",
      render: (_, coupon) => (
        coupon.is_active ? (
          <Badge variant="default" className="bg-green-500 hover:bg-green-600">Active</Badge>
        ) : (
          <Badge variant="secondary">Inactive</Badge>
        )
      ),
    },
    {
      key: "id",
      label: "",
      width: "80px",
      render: (_, coupon) => (
        <div className="flex justify-end w-full">
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="ghost" className="h-8 w-8 p-0">
                <span className="sr-only">Open menu</span>
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onClick={() => handleOpenEdit(coupon)}>
                <Pencil className="mr-2 h-4 w-4" />
                Edit
              </DropdownMenuItem>
              <DropdownMenuItem
                onClick={() => confirmDelete(coupon.id)}
                className="text-red-600 focus:text-red-600 focus:bg-red-50"
              >
                <Trash2 className="mr-2 h-4 w-4" />
                Delete
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      ),
    },
  ];

  if (isLoading) {
    return (
      <div className="flex h-[400px] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (isError) {
    return (
      <div className="flex h-[400px] flex-col items-center justify-center gap-4 text-red-500">
        <p>Failed to load coupons.</p>
        <Button variant="outline" onClick={() => refetch()}>
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <PageHeaderwithAddButton
          title="Coupon & Promotional Campaigns"
          description="Create and manage discount codes, define validity periods, and monitor usage limits."
        />
        <Button onClick={handleOpenCreate}>
          <Plus className="mr-2 h-4 w-4" />
          Create Campaign
        </Button>
      </div>

      <DataTable
        columns={columns}
        data={coupons || []}
        isLoading={false}
        emptyMessage="No promotional campaigns found."
      />

      <CouponDialog
        open={dialogOpen}
        onOpenChange={setDialogOpen}
        coupon={selectedCoupon}
        onSubmit={handleDialogSubmit}
        isSubmitting={createMutation.isPending || updateMutation.isPending}
      />

      <AlertDialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
            <AlertDialogDescription>
              This action cannot be undone. This will permanently delete the promotional campaign.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancel</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDelete}
              className="bg-red-600 hover:bg-red-700"
              disabled={deleteMutation.isPending}
            >
              {deleteMutation.isPending ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

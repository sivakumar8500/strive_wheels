"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Textarea } from "@/components/ui/textarea";
import { DriverRegistration } from "../types";
import { useVerifyDocument, useApproveApplication } from "../hooks/use-drivers";
import { Check, X, Loader2 } from "lucide-react";
import { Badge } from "@/components/ui/badge";

interface KycReviewDialogProps {
  driver: DriverRegistration | null;
  isOpen: boolean;
  onClose: () => void;
}

export function KycReviewDialog({ driver, isOpen, onClose }: KycReviewDialogProps) {
  const [rejectingDocId, setRejectingDocId] = useState<number | null>(null);
  const [rejectionReason, setRejectionReason] = useState("");

  const verifyDocMutation = useVerifyDocument();
  const approveAppMutation = useApproveApplication();

  if (!driver) return null;

  const handleApproveDoc = (docId: number) => {
    verifyDocMutation.mutate({
      registrationId: driver.id,
      documentId: docId,
      status: "APPROVED",
    });
  };

  const handleRejectDoc = (docId: number) => {
    if (!rejectionReason) return;
    verifyDocMutation.mutate(
      {
        registrationId: driver.id,
        documentId: docId,
        status: "REJECTED",
        rejectionReason,
      },
      {
        onSuccess: () => {
          setRejectingDocId(null);
          setRejectionReason("");
        },
      }
    );
  };

  const handleApproveApplication = () => {
    approveAppMutation.mutate(driver.id, {
      onSuccess: () => {
        onClose();
      },
    });
  };

  const allDocsApproved = driver.documents.every(
    (doc) => doc.status === "APPROVED"
  );

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>KYC Review: {driver.personal_info.first_name} {driver.personal_info.last_name}</DialogTitle>
        </DialogHeader>

        <div className="grid grid-cols-2 gap-6 mt-4">
          <div className="space-y-4">
            <h3 className="font-semibold text-lg border-b pb-2">Personal Information</h3>
            <div className="grid grid-cols-2 gap-2 text-sm">
              <span className="text-slate-500">First Name:</span>
              <span className="font-medium">{driver.personal_info.first_name}</span>
              <span className="text-slate-500">Last Name:</span>
              <span className="font-medium">{driver.personal_info.last_name}</span>
              <span className="text-slate-500">Mobile:</span>
              <span className="font-medium">{driver.personal_info.mobile_number}</span>
            </div>

            <h3 className="font-semibold text-lg border-b pb-2 mt-6">Vehicle Details</h3>
            <div className="grid grid-cols-2 gap-2 text-sm">
              <span className="text-slate-500">Make:</span>
              <span className="font-medium">{driver.vehicle_details.make}</span>
              <span className="text-slate-500">Model:</span>
              <span className="font-medium">{driver.vehicle_details.model}</span>
              <span className="text-slate-500">Plate Number:</span>
              <span className="font-medium">{driver.vehicle_details.plate_number}</span>
            </div>
          </div>

          <div className="space-y-4">
            <h3 className="font-semibold text-lg border-b pb-2">Documents</h3>
            <div className="space-y-4">
              {driver.documents.map((doc) => (
                <div key={doc.id} className="border rounded-lg p-3 space-y-3">
                  <div className="flex justify-between items-center">
                    <span className="font-medium">{doc.document_type}</span>
                    <Badge
                      variant={
                        doc.status === "APPROVED"
                          ? "default"
                          : doc.status === "REJECTED"
                          ? "destructive"
                          : "secondary"
                      }
                    >
                      {doc.status}
                    </Badge>
                  </div>

                  <div className="aspect-video bg-slate-100 rounded-md overflow-hidden relative">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img
                      src={doc.document_url}
                      alt={doc.document_type}
                      className="w-full h-full object-cover"
                    />
                  </div>

                  {doc.status === "REJECTED" && doc.rejection_reason && (
                    <div className="text-sm text-red-500 bg-red-50 p-2 rounded-md">
                      Reason: {doc.rejection_reason}
                    </div>
                  )}

                  {doc.status === "PENDING" && (
                    <div className="flex gap-2">
                      <Button
                        size="sm"
                        variant="outline"
                        className="flex-1 text-green-600 hover:text-green-700 hover:bg-green-50"
                        onClick={() => handleApproveDoc(doc.id)}
                        disabled={verifyDocMutation.isPending}
                      >
                        <Check className="w-4 h-4 mr-2" />
                        Approve
                      </Button>
                      <Button
                        size="sm"
                        variant="outline"
                        className="flex-1 text-red-600 hover:text-red-700 hover:bg-red-50"
                        onClick={() => setRejectingDocId(doc.id)}
                        disabled={verifyDocMutation.isPending}
                      >
                        <X className="w-4 h-4 mr-2" />
                        Reject
                      </Button>
                    </div>
                  )}

                  {rejectingDocId === doc.id && (
                    <div className="space-y-2 mt-2">
                      <Textarea
                        placeholder="Reason for rejection..."
                        value={rejectionReason}
                        onChange={(e) => setRejectionReason(e.target.value)}
                        rows={2}
                      />
                      <div className="flex gap-2 justify-end">
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => {
                            setRejectingDocId(null);
                            setRejectionReason("");
                          }}
                        >
                          Cancel
                        </Button>
                        <Button
                          size="sm"
                          variant="destructive"
                          onClick={() => handleRejectDoc(doc.id)}
                          disabled={!rejectionReason || verifyDocMutation.isPending}
                        >
                          Confirm Rejection
                        </Button>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="mt-6 flex justify-end border-t pt-4">
          <Button
            size="lg"
            disabled={!allDocsApproved || driver.status === "APPROVED" || approveAppMutation.isPending}
            onClick={handleApproveApplication}
          >
            {approveAppMutation.isPending && (
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
            )}
            {driver.status === "APPROVED" ? "Account Approved" : "Approve Account"}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}

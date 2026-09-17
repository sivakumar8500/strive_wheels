"use client";

import { useState, useMemo } from "react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { useVerifyDocument, useReviewApplication, useDriverDetails } from "../hooks/use-drivers";
import { Check, X, Loader2, ArrowLeft, Car, MapPin, Building2, Phone, Mail, Calendar, Hash, User } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { useRouter } from "next/navigation";
import { format } from "date-fns";

interface Props {
  driverId: number;
}

export function DriverRegistrationDetailsClient({ driverId }: Props) {
  const router = useRouter();
  const [rejectingDocId, setRejectingDocId] = useState<number | null>(null);
  const [rejectionReason, setRejectionReason] = useState("");

  const { data: driver, isLoading, isError } = useDriverDetails(driverId);
  const verifyDocMutation = useVerifyDocument();
  const reviewAppMutation = useReviewApplication();

  const handleApproveDoc = (docId: number) => {
    verifyDocMutation.mutate({
      registrationId: driverId,
      documentId: docId,
      status: "APPROVED",
    });
  };

  const handleRejectDoc = (docId: number) => {
    if (!rejectionReason) return;
    verifyDocMutation.mutate(
      {
        registrationId: driverId,
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
    reviewAppMutation.mutate({
      registrationId: driverId,
      status: "APPROVED",
    });
  };

  // Grouping documents and extracting selfie
  const { allKycDocs, allPairs, personalPairs, vehiclePairs, liveSelfie } = useMemo(() => {
    if (!driver) return { allKycDocs: [], allPairs: [], personalPairs: [], vehiclePairs: [], liveSelfie: null };

    const docs = [
      ...(driver.kyc_documents || []),
      ...(driver.vehicle_detail?.documents || [])
    ];

    const selfie = docs.find(d => d.document_type === "LIVE_SELFIE") || null;
    
    const personalDocs = (driver.kyc_documents || []).filter(d => d.document_type !== "LIVE_SELFIE");
    const vehicleDocs = driver.vehicle_detail?.documents || [];

    const processPairs = (docList: typeof personalDocs) => {
      const pairs: { title: string; docs: typeof personalDocs }[] = [];
      const processed = new Set<number>();

      docList.forEach((doc) => {
        if (processed.has(doc.id)) return;

        let groupTitle = doc.document_type.replace(/_/g, " ");
        let pairDoc: typeof doc | undefined;

        if (doc.document_type.includes("FRONT")) {
          const backType = doc.document_type.replace("FRONT", "BACK");
          pairDoc = docList.find((d) => d.document_type === backType);
          groupTitle = doc.document_type.replace("_FRONT", "").replace("FRONT_", "").replace(/_/g, " ");
        } else if (doc.document_type.includes("LEFT")) {
          const rightType = doc.document_type.replace("LEFT", "RIGHT");
          pairDoc = docList.find((d) => d.document_type === rightType);
          groupTitle = "SIDE VIEWS";
        } else if (doc.document_type === "RC") {
          pairDoc = docList.find((d) => d.document_type === "RC_BACK");
          groupTitle = "RC";
        }

        if (pairDoc) {
          pairs.push({ title: groupTitle, docs: [doc, pairDoc] });
          processed.add(doc.id);
          processed.add(pairDoc.id);
        } else {
          pairs.push({ title: groupTitle, docs: [doc] });
          processed.add(doc.id);
        }
      });
      
      return pairs;
    };

    const pPairs = processPairs(personalDocs);
    const vPairs = processPairs(vehicleDocs);

    return { 
      allKycDocs: docs, 
      allPairs: [...pPairs, ...vPairs], 
      personalPairs: pPairs, 
      vehiclePairs: vPairs, 
      liveSelfie: selfie 
    };
  }, [driver]);

  if (isLoading) {
    return (
      <div className="flex h-[400px] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (isError || !driver) {
    return (
      <div className="flex h-[400px] flex-col items-center justify-center gap-4 text-red-500">
        <p>Failed to load driver details.</p>
        <Button variant="outline" onClick={() => router.back()}>
          Go Back
        </Button>
      </div>
    );
  }

  const allDocsApproved = allKycDocs.every(doc => doc.verification_status === "APPROVED");

  const InfoItem = ({ icon: Icon, label, value }: { icon: any, label: string, value: string | number | undefined }) => (
    <div className="flex items-start gap-3 text-sm">
      <div className="mt-0.5 bg-slate-100 p-1.5 rounded-md text-slate-500"><Icon className="w-4 h-4" /></div>
      <div className="flex flex-col">
        <span className="text-xs text-slate-500 font-medium uppercase tracking-wider">{label}</span>
        <span className="font-semibold text-slate-900">{value || "N/A"}</span>
      </div>
    </div>
  );

  return (
    <div className="space-y-6 pb-20">
      {/* HEADER SECTION */}
      <div className="flex items-center gap-4 mb-4">
        <Button variant="ghost" size="icon" onClick={() => router.back()} className="rounded-full bg-slate-50 hover:bg-slate-100 shadow-sm border border-slate-200">
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <div className="flex-1">
          <h1 className="text-2xl font-bold tracking-tight text-slate-900">Application Review</h1>
          <p className="text-slate-500 text-sm">Review profile, verify documents, and approve.</p>
        </div>
        <div className="flex items-center gap-4">
           <div className="flex flex-col items-end">
             <span className="text-xs text-slate-500 uppercase font-semibold">Status</span>
             <Badge variant={driver.status === "APPROVED" ? "default" : driver.status === "REJECTED" ? "destructive" : "secondary"} className="text-sm px-3 mt-1">
                {driver.status}
             </Badge>
           </div>
           <Button
              size="lg"
              className="shadow-sm hover:shadow-md transition-shadow font-semibold"
              disabled={!allDocsApproved || driver.status === "APPROVED" || reviewAppMutation.isPending}
              onClick={handleApproveApplication}
            >
              {reviewAppMutation.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              {driver.status === "APPROVED" ? "Fully Approved" : "Approve Account"}
            </Button>
        </div>
      </div>

      {/* PROFILE CARD */}
      <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 lg:p-8 flex flex-col md:flex-row gap-8 items-start">
        {/* Selfie & Core Info */}
        <div className="flex gap-6 items-center flex-shrink-0">
          <div className="relative">
            <div className="w-32 h-32 lg:w-40 lg:h-40 rounded-full overflow-hidden border-4 border-slate-50 shadow-md bg-slate-100">
              {liveSelfie ? (
                // eslint-disable-next-line @next/next/no-img-element
                <img src={liveSelfie.file_url} alt="Selfie" className="w-full h-full object-cover" />
              ) : (
                <div className="w-full h-full flex items-center justify-center text-slate-400">
                  <User className="w-12 h-12" />
                </div>
              )}
            </div>
            {liveSelfie && (
              <Badge 
                variant={liveSelfie.verification_status === "APPROVED" ? "default" : liveSelfie.verification_status === "REJECTED" ? "destructive" : "secondary"}
                className="absolute -bottom-2 left-1/2 -translate-x-1/2 px-3 shadow-sm border-2 border-white"
              >
                {liveSelfie.verification_status}
              </Badge>
            )}
          </div>
          <div className="space-y-2">
            <h2 className="text-3xl font-bold text-slate-900 tracking-tight">
              {driver.personal_info?.first_name} {driver.personal_info?.last_name}
            </h2>
            <div className="text-slate-500 font-medium">{driver.personal_info?.mobile_number}</div>
            {driver.personal_info?.email && <div className="text-slate-500 text-sm">{driver.personal_info.email}</div>}
            
            {/* Selfie Verification Actions */}
            {liveSelfie && (liveSelfie.verification_status === "PENDING" || liveSelfie.verification_status === "UPLOADED" || liveSelfie.verification_status === "UNVERIFIED") && (
              <div className="flex gap-2 pt-3">
                <Button size="sm" variant="outline" className="h-8 border-green-200 text-green-700 hover:bg-green-50" onClick={() => handleApproveDoc(liveSelfie.id)}>
                  <Check className="w-3.5 h-3.5 mr-1.5" /> Approve
                </Button>
                <Button size="sm" variant="outline" className="h-8 border-red-200 text-red-700 hover:bg-red-50" onClick={() => setRejectingDocId(liveSelfie.id)}>
                  <X className="w-3.5 h-3.5 mr-1.5" /> Reject
                </Button>
              </div>
            )}
          </div>
        </div>

        {/* Extended Profile Info */}
        <div className="flex-1 w-full grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-6 pt-4 md:pt-0 md:pl-8 md:border-l border-slate-100">
          <InfoItem icon={User} label="Gender" value={driver.personal_info?.gender} />
          <InfoItem icon={Calendar} label="D.O.B" value={driver.personal_info?.dob} />
          <InfoItem icon={Hash} label="Referral Code" value={driver.personal_info?.referral_code || "None"} />
          <InfoItem icon={Calendar} label="Applied On" value={driver.submitted_at ? format(new Date(driver.submitted_at), "PP") : "N/A"} />
          <InfoItem icon={Hash} label="Driver ID" value={driver.registration_id} />
          <InfoItem icon={User} label="User ID" value={driver.user_id} />
        </div>
      </div>

      {/* Rejection input for selfie if needed */}
      {liveSelfie && rejectingDocId === liveSelfie.id && (
         <div className="bg-white p-4 rounded-xl border border-red-100 shadow-sm max-w-md mx-auto">
           <Textarea placeholder="Reason for rejecting selfie..." value={rejectionReason} onChange={(e) => setRejectionReason(e.target.value)} rows={2} className="resize-none text-sm mb-3" />
           <div className="flex gap-2 justify-end">
             <Button size="sm" variant="ghost" onClick={() => { setRejectingDocId(null); setRejectionReason(""); }}>Cancel</Button>
             <Button size="sm" variant="destructive" onClick={() => handleRejectDoc(liveSelfie.id)} disabled={!rejectionReason}>Confirm Rejection</Button>
           </div>
         </div>
      )}

      {/* METADATA CARDS */}
      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4">
        <div className="bg-white rounded-xl border border-slate-200 p-5 shadow-sm space-y-4">
          <div className="flex items-center justify-between text-slate-700">
            <div className="flex items-center gap-2">
              <Car className="w-4 h-4"/><h3 className="font-semibold text-sm">Vehicle</h3>
            </div>
            {driver.vehicle_detail?.fuel_type && (
               <Badge variant="outline" className="text-[10px] text-slate-500">{driver.vehicle_detail.fuel_type}</Badge>
            )}
          </div>
          <div className="space-y-3">
            <div className="flex justify-between text-sm"><span className="text-slate-500">Make & Model</span><span className="font-medium text-right truncate w-32" title={`${driver.vehicle_detail?.compenyName} ${driver.vehicle_detail?.vehicalModel}`}>{driver.vehicle_detail?.compenyName} {driver.vehicle_detail?.vehicalModel}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">Plate</span><span className="font-medium text-right uppercase">{driver.vehicle_detail?.registrationNumber}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">Color / Year</span><span className="font-medium text-right capitalize">{driver.vehicle_detail?.registrationcolor || "-"} • {driver.vehicle_detail?.registrationyear}</span></div>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-slate-200 p-5 shadow-sm space-y-4">
          <div className="flex items-center gap-2 text-slate-700"><MapPin className="w-4 h-4"/><h3 className="font-semibold text-sm">Address</h3></div>
          <div className="space-y-3">
            <div className="flex justify-between text-sm"><span className="text-slate-500">Street</span><span className="font-medium text-right truncate w-32" title={`${driver.address?.house_no} ${driver.address?.street_area}`}>{driver.address?.house_no} {driver.address?.street_area}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">City</span><span className="font-medium text-right">{driver.address?.city}, {driver.address?.state}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">PIN</span><span className="font-medium text-right">{driver.address?.pincode}</span></div>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-slate-200 p-5 shadow-sm space-y-4">
          <div className="flex items-center gap-2 text-slate-700"><Building2 className="w-4 h-4"/><h3 className="font-semibold text-sm">Bank</h3></div>
          <div className="space-y-3">
            <div className="flex justify-between text-sm"><span className="text-slate-500">Holder</span><span className="font-medium text-right truncate w-32" title={driver.bank_account?.account_holder_name}>{driver.bank_account?.account_holder_name}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">Bank</span><span className="font-medium text-right">{driver.bank_account?.bank_name}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">A/C No</span><span className="font-medium text-right">{driver.bank_account?.account_number_masked}</span></div>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-slate-200 p-5 shadow-sm space-y-4">
          <div className="flex items-center gap-2 text-slate-700"><Phone className="w-4 h-4"/><h3 className="font-semibold text-sm">Emergency</h3></div>
          <div className="space-y-3">
            <div className="flex justify-between text-sm"><span className="text-slate-500">Name</span><span className="font-medium text-right truncate w-32" title={driver.emergency_contact?.contact_name}>{driver.emergency_contact?.contact_name}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">Rel.</span><span className="font-medium text-right">{driver.emergency_contact?.relationship_type}</span></div>
            <div className="flex justify-between text-sm"><span className="text-slate-500">Phone</span><span className="font-medium text-right">{driver.emergency_contact?.phone_number}</span></div>
          </div>
        </div>
      </div>

      {/* DOCUMENTS GRID */}
      <div className="pt-2">
        <Tabs defaultValue="all" className="w-full flex flex-col">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
            <h3 className="text-lg font-bold text-slate-900">Verification Documents</h3>
            <TabsList className="bg-slate-100 p-1 w-full sm:w-auto h-auto">
              <TabsTrigger value="all" className="text-xs sm:text-sm py-1.5 px-4 data-[state=active]:bg-white data-[state=active]:shadow-sm rounded-md">All ({allPairs.length})</TabsTrigger>
              <TabsTrigger value="personal" className="text-xs sm:text-sm py-1.5 px-4 data-[state=active]:bg-white data-[state=active]:shadow-sm rounded-md">Identity ({personalPairs.length})</TabsTrigger>
              <TabsTrigger value="vehicle" className="text-xs sm:text-sm py-1.5 px-4 data-[state=active]:bg-white data-[state=active]:shadow-sm rounded-md">Vehicle ({vehiclePairs.length})</TabsTrigger>
            </TabsList>
          </div>

          {[
            { id: "all", pairs: allPairs, emptyMsg: "No documents uploaded." },
            { id: "personal", pairs: personalPairs, emptyMsg: "No personal identity documents found." },
            { id: "vehicle", pairs: vehiclePairs, emptyMsg: "No vehicle documents found." }
          ].map(tab => (
            <TabsContent key={tab.id} value={tab.id} className="mt-0 outline-none">
              {tab.pairs.length === 0 ? (
                 <div className="text-center text-slate-500 text-sm py-12 bg-slate-50 rounded-xl border border-dashed border-slate-200">
                   {tab.emptyMsg}
                 </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 gap-6">
                  {tab.pairs.map((group, idx) => (
                    <div key={idx} className="bg-white border border-slate-200 rounded-xl p-4 shadow-sm flex flex-col">
                      <h4 className="text-sm font-bold text-slate-800 capitalize mb-3 pb-2 border-b border-slate-100">
                        {group.title.toLowerCase()}
                      </h4>
                      
                      <div className={`grid grid-cols-1 ${group.docs.length === 2 ? 'gap-3' : ''} flex-1`}>
                        {group.docs.map((doc) => (
                          <div key={doc.id} className="flex flex-col space-y-3">
                            <div className="flex justify-between items-center">
                              <span className="font-medium text-xs text-slate-500">{doc.document_type.replace(/_/g, " ")}</span>
                              <Badge variant={doc.verification_status === "APPROVED" ? "default" : doc.verification_status === "REJECTED" ? "destructive" : "secondary"} className="text-[10px] px-1.5 py-0">
                                {doc.verification_status}
                              </Badge>
                            </div>

                            <div className="aspect-[4/3] bg-slate-100 rounded-lg overflow-hidden border border-slate-200 relative">
                              {/* eslint-disable-next-line @next/next/no-img-element */}
                              <img src={doc.file_url} alt={doc.document_type} className="w-full h-full object-cover hover:object-contain transition-all duration-300" />
                            </div>

                            {doc.verification_status === "REJECTED" && doc.rejection_reason && (
                              <div className="text-xs text-red-600 bg-red-50 p-2 rounded-md border border-red-100 mt-auto">
                                <span className="font-semibold">Rejected:</span> {doc.rejection_reason}
                              </div>
                            )}

                            {(doc.verification_status === "PENDING" || doc.verification_status === "UNVERIFIED" || doc.verification_status === "UPLOADED") && (
                              <div className="flex gap-2 mt-auto pt-1">
                                <Button size="sm" variant="outline" className="flex-1 h-7 text-xs border-green-200 text-green-700 hover:bg-green-50" onClick={() => handleApproveDoc(doc.id)} disabled={verifyDocMutation.isPending}>
                                  <Check className="w-3 h-3 mr-1" /> Approve
                                </Button>
                                <Button size="sm" variant="outline" className="flex-1 h-7 text-xs border-red-200 text-red-700 hover:bg-red-50" onClick={() => setRejectingDocId(doc.id)} disabled={verifyDocMutation.isPending}>
                                  <X className="w-3 h-3 mr-1" /> Reject
                                </Button>
                              </div>
                            )}

                            {rejectingDocId === doc.id && (
                              <div className="space-y-2 mt-2 p-3 bg-slate-50 border border-slate-200 rounded-lg">
                                <Textarea placeholder="Reason..." value={rejectionReason} onChange={(e) => setRejectionReason(e.target.value)} rows={2} className="resize-none text-xs h-12" />
                                <div className="flex gap-2 justify-end">
                                  <Button size="sm" variant="ghost" className="h-6 text-xs px-2" onClick={() => { setRejectingDocId(null); setRejectionReason(""); }}>Cancel</Button>
                                  <Button size="sm" variant="destructive" className="h-6 text-xs px-2" onClick={() => handleRejectDoc(doc.id)} disabled={!rejectionReason || verifyDocMutation.isPending}>Confirm</Button>
                                </div>
                              </div>
                            )}
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </TabsContent>
          ))}
        </Tabs>
      </div>
    </div>
  );
}
